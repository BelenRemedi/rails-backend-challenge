# == Schema Information
#
# Table name: availabilities
#
#  id          :integer          not null, primary key
#  end_dow     :integer          not null
#  end_time    :time             not null
#  source      :string           default("calendly"), not null
#  start_dow   :integer          not null
#  start_time  :time             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :string           not null
#  provider_id :integer          not null
#
# Indexes
#
#  index_availabilities_on_provider_id                             (provider_id)
#  index_availabilities_on_provider_id_and_source_and_external_id  (provider_id,source,external_id) UNIQUE
#
# Foreign Keys
#
#  provider_id  (provider_id => providers.id)
#
class Availability < ApplicationRecord
  belongs_to :provider

  DOW = {
    "monday"    => 1,
    "tuesday"   => 2,
    "wednesday" => 3,
    "thursday"  => 4,
    "friday"    => 5,
    "saturday"  => 6,
    "sunday"    => 0
  }.freeze

  validates :start_dow, :end_dow, inclusion: { in: DOW.values }
  validates :start_time, :end_time, presence: true
  validates :end_time, comparison: { greater_than: :start_time }
  validates :end_dow, comparison: { greater_than_or_equal_to: :start_dow }
  validates :source, presence: true, inclusion: { in: %w[calendly] }
  validates :external_id, presence: true, uniqueness: { scope: %i[provider_id source] }
end
