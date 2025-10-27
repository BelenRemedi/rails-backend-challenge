require 'rails_helper'

RSpec.describe AppointmentsController do
  describe "POST /appointments" do
    let(:client) { create(:client) }
    let(:provider) { create(:provider) }
    let!(:availability) { create(:availability, provider: provider, start_dow: 1, end_dow: 1, start_time: "09:00", end_time: "17:00") } # Monday


    context "with valid parameters" do
      it "creates a new appointment" do
        post appointments_path, params: {
          client_id: client.id,
          provider_id: provider.id,
          starts_at: "2025-10-27T10:00:00Z",
          ends_at: "2025-10-27T11:00:00Z"
        }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include("client_id" => client.id, "provider_id" => provider.id)
      end
    end

    context "with invalid time slot" do
      it "returns an error when the slot is not available" do
        post appointments_path, params: {
          client_id: client.id,
          provider_id: provider.id,
          starts_at: "2025-10-27T08:00:00Z",
          ends_at: "2025-10-27T09:00:00Z"
        }

        expect(response).to have_http_status("422")
        expect(JSON.parse(response.body)).to include("error" => "Requested slot is not available")
      end
    end
  end
end
