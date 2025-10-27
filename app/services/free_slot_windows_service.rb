class FreeSlotWindowsService
  attr_reader :provider, :from_date, :to_date

  def initialize(provider:, from_date:, to_date:)
    @provider = provider
    @from_date = from_date
    @to_date = to_date
  end

  # @return [Array<(Time, Time)>] list of free slot windows as [start_at, end_at] pairs in UTC
  def call
    occurrences = []

    Time.use_zone(provider.time_zone) do
      from_local = from_date.in_time_zone(Time.zone)
      to_local = to_date.in_time_zone(Time.zone)
      provider.availabilities.find_each do |availability|
        # iterate by day in the requested range
        (from_local.to_date..to_local.to_date).each do |date|
          next unless date.wday == availability.start_dow

          start_dt = Time.zone.local(date.year, date.month, date.day, availability.start_time.hour, availability.start_time.min)
          end_dt = Time.zone.local(date.year, date.month, date.day, availability.end_time.hour, availability.end_time.min)

          # if crosses midnight (e.g. monday 22:00 → tuesday 01:00)
          end_dt += 1.day if availability.end_dow != availability.start_dow || end_dt <= start_dt

          # only keep if within requested range
          if start_dt < to_local && end_dt > from_local
            occurrences << [ start_dt, end_dt ]
          end
        end
      end
    end

    # appointments that overlap with the requested range
    #
    bookings = provider.appointments.scheduled
                  .where("end_date > ? AND start_date < ?", from_date, to_date)
                  .pluck(:start_date, :end_date)
                  .map { |s, e| [ s.in_time_zone(provider.time_zone), e.in_time_zone(provider.time_zone) ] }

    subtract_intervals(occurrences, bookings)
  end

  private

  def subtract_intervals(availabilities, bookings)
    free = availabilities
    bookings.each do |(b_start, b_end)|
      free = free.flat_map do |(a_start, a_end)|
        next [ [ a_start, a_end ] ] if b_end <= a_start || b_start >= a_end # no overlap
        parts = []
        parts << [ a_start.utc, b_start.utc ] if b_start > a_start
        parts << [ b_end.utc, a_end.utc ] if b_end < a_end
        parts
      end
    end
    free
  end
end
