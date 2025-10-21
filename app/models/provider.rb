# == Schema Information
#
# Table name: providers
#
#  id          :integer          not null, primary key
#  source      :string           default("calendly"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :string           not null
#
# Indexes
#
#  index_providers_on_source_and_external_id  (source,external_id) UNIQUE
#
class Provider < ApplicationRecord
  has_many :availabilities, dependent: :destroy
  has_many :appointments, dependent: :destroy
end
