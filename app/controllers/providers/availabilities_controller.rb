module Providers
  class AvailabilitiesController < ApplicationController
    # GET /providers/:provider_id/availabilities
    # Expected params: from, to (ISO8601 timestamps)
    def index
      provider = Provider.find(params[:provider_id])
      from_utc = Time.iso8601(params[:from])
      to_utc = Time.iso8601(params[:to])

      free_slot_windows = FreeSlotWindowsService.new(provider: provider, from_date: from_utc, to_date: to_utc).call

      render json: free_slot_windows.map { |(start_at, end_at)| { start_at: start_at.iso8601, end_at: end_at.iso8601 } }
    end
  end
end
