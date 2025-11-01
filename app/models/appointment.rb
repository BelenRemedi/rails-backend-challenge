# == Schema Information
#
# Table name: appointments
#
#  id          :integer          not null, primary key
#  end_date    :datetime         not null
#  start_date  :datetime         not null
#  status      :integer          default("scheduled"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  client_id   :integer          not null
#  provider_id :integer          not null
#
# Indexes
#
#  index_appointments_on_client_id    (client_id)
#  index_appointments_on_provider_id  (provider_id)
#
# Foreign Keys
#
#  client_id    (client_id => clients.id)
#  provider_id  (provider_id => providers.id)
#
class Appointment < ApplicationRecord
  belongs_to :provider
  belongs_to :client

  enum :status, { scheduled: 0, completed: 1, canceled: 2 }

  validate :no_overlapping_appointments

  private

  def no_overlapping_appointments
    overlapping_appointments = Appointment.scheduled
      .where(provider_id: provider_id)
      .where.not(id: id)
      .where("start_date < ? AND end_date > ?", end_date, start_date)

    if overlapping_appointments.exists?
      errors.add(:base, "Appointment overlaps with an existing appointment for the provider")
    end
  end
end
