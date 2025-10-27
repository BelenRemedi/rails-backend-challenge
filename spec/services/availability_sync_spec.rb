require "rails_helper"

describe AvailabilitySync do
  let(:provider) { create(:provider, external_id: "provider-123") }

  describe "#call" do
    it "creates or updates Availability records based on Calendly slots" do
      client = instance_double(CalendlyClient)
      allow(client).to receive(:fetch_slots).with("provider-123").and_return([
        {
          "id" => "slot-1",
          "source" => "calendly",
          "starts_at" => { "day_of_week" => "monday", "time" => "09:00:00" },
          "ends_at" => { "day_of_week" => "monday", "time" => "17:00:00" }
        },
        {
          "id" => "slot-2",
          "source" => "calendly",
          "starts_at" => { "day_of_week" => "tuesday", "time" => "10:00:00" },
          "ends_at" => { "day_of_week" => "tuesday", "time" => "18:00:00" }
        }
      ])
      sync = AvailabilitySync.new(client: client)
      expect {
        sync.call(provider_id: provider.id)
      }.to change { Availability.count }.by(2)
    end
  end
end
