require "rails_helper"

describe FreeSlotWindowsService do
  let(:provider) { create(:provider) }

  describe "#call" do
    it "returns free slot windows excluding booked appointments" do
      create(:availability, provider: provider, start_dow: 1, end_dow: 1, start_time: "09:00", end_time: "17:00") # Monday
      create(:appointment, provider: provider, start_date: "2025-10-27 13:00 UTC", end_date: "2025-10-27 14:00 UTC", status: :scheduled) # Monday

      service = FreeSlotWindowsService.new(
        provider: provider,
        from_date: Time.utc(2025, 10, 27, 0, 0),   # June 3, 2024
        to_date:   Time.utc(2025, 10, 28, 0, 0)    # June 4, 2024
      )

      free_slots = service.call

      expect(free_slots).to eq([
        [ Time.utc(2025, 10, 27, 9, 0), Time.utc(2025, 10, 27, 13, 0) ], # before booked slot
        [ Time.utc(2025, 10, 27, 14, 0), Time.utc(2025, 10, 27, 17, 0) ]  # after booked slot
      ])
    end
  end
end
