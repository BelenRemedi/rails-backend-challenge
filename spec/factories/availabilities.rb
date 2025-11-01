FactoryBot.define do
  factory :availability do
    start_dow { 1 }
    start_time { "09:00:00" }
    end_dow { 1 }
    end_time { "17:00:00" }
    source { "calendly" }
    external_id { SecureRandom.uuid }
    provider
  end
end
