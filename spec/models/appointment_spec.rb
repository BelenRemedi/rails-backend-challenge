require "rails_helper"

RSpec.describe Appointment do
  describe "validations" do
    describe "#no_overlapping_appointments" do
      let(:provider) { Provider.create!(external_id: "prov_1") }
      let(:client) { Client.create!(name: "Client 1") }

      it "is invalid if there is an overlapping appointment for the same provider" do
        Appointment.create!(
          provider: provider,
          client: client,
          start_date: Time.utc(2024, 1, 1, 10, 0, 0),
          end_date: Time.utc(2024, 1, 1, 11, 0, 0),
          status: :scheduled
        )

        overlapping_appointment = Appointment.new(
          provider: provider,
          client: client,
          start_date: Time.utc(2024, 1, 1, 10, 30, 0),
          end_date: Time.utc(2024, 1, 1, 11, 30, 0),
          status: :scheduled
        )

        expect(overlapping_appointment).not_to be_valid
        expect(overlapping_appointment.errors[:base]).to include("Appointment overlaps with an existing appointment for the provider")
      end

      it "is valid if there are no overlapping appointments for the same provider" do
        Appointment.create!(
          provider: provider,
          client: client,
          start_date: Time.utc(2024, 1, 1, 12, 0, 0),
          end_date: Time.utc(2024, 1, 1, 13, 0, 0),
          status: :scheduled
        )

        non_overlapping_appointment = Appointment.new(
          provider: provider,
          client: client,
          start_date: Time.utc(2024, 1, 1, 13, 30, 0),
          end_date: Time.utc(2024, 1, 1, 14, 30, 0),
          status: :scheduled
        )

        expect(non_overlapping_appointment).to be_valid
      end
    end
  end
end
