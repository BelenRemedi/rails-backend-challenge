# == Schema Information
#
# Table name: appointments
#
#  id                                        :integer          not null, primary key
#  end_date                                  :datetime         not null
#  start_date                                :datetime         not null
#  status                                    :integer          not null
#  {scheduled: 0, completed: 1, canceled: 2} :integer          not null
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  client_id                                 :integer          not null
#  provider_id                               :integer          not null
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

  enum status: { scheduled: 0, completed: 1, canceled: 2 }
end
