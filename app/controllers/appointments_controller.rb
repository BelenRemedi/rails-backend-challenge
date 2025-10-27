class AppointmentsController < ApplicationController
  # POST /appointments
  # Params: client_id, provider_id, starts_at, ends_at
  def create
    client = Client.find(params[:client_id])
    provider = Provider.find(params[:provider_id])
    begin
      start_date = Time.iso8601(params[:starts_at])
      end_date = Time.iso8601(params[:ends_at])
    rescue ArgumentError
      render json: { error: "Invalid ISO8601 for start_at/end_at" }, status: :bad_request and return
    end

    if start_date >= end_date
      render json: { error: "starts_at must be before ends_at" }, status: :unprocessable_entity and return
    end

    from_date = start_date.beginning_of_day - 1.day
    to_date   = end_date.end_of_day

    free_windows = FreeSlotWindowsService
      .new(provider: provider, from_date: from_date, to_date: to_date)
      .call

    fitting_slots = free_windows.any? { |(free_start, free_end)| start_date >= free_start && end_date <= free_end }
    unless fitting_slots
      render json: { error: "Requested slot is not available" }, status: :unprocessable_entity and return
    end

    appointment = provider.appointments.new(client: client, start_date: start_date, end_date: end_date, status: :scheduled)

    if appointment.save
      render json: { id: appointment.id, client_id: appointment.client_id, provider_id: appointment.provider_id, start_date: appointment.start_date.iso8601, end_date: appointment.end_date.iso8601, status: appointment.status }, status: :created
    else
      render json: { error: appointment.errors.full_messages }, status: :conflict
    end
  end

  # DELETE /appointments/:id
  # Bonus: cancel an appointment instead of deleting
  def destroy
    appointment = Appointment.find(params[:id])
    appointment.status = :canceled
    if appointment.save
      render json: { message: "Appointment canceled successfully" }, status: :ok
    else
      render json: { error: appointment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def appointment_params
    params.permit(:provider_id, :client_id, :starts_at, :ends_at)
  end
end
