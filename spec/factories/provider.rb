FactoryBot.define do
  factory :provider do
    source { "calendly" }
    external_id { SecureRandom.uuid }
  end
end
