class AvailabilitySync
  def initialize(client: CalendlyClient.new)
    @client = client
  end

  # Syncs availabilities for a provider based on the Calendly feed.
  # Candidates should fetch slots from the CalendlyClient and upsert Availability records.
  def call(provider_id:)
    provider = Provider.find(provider_id)
    client.fetch_slots(provider.external_id).each do |slot|
      Availability.find_or_initialize_by(
        provider: provider,
        source: slot.fetch("source"),
        external_id: slot.fetch("id")
      ).tap do |availability|
        availability.start_dow = Availability::DOW.fetch(slot.dig("starts_at", "day_of_week"))
        availability.start_time = slot.dig("starts_at", "time")
        availability.end_dow = Availability::DOW.fetch(slot.dig("ends_at", "day_of_week"))
        availability.end_time = slot.dig("ends_at", "time")
        availability.save!
      end
    end
  end

  private

  attr_reader :client
end
