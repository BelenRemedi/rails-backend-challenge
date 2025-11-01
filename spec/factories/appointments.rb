FactoryBot.define do
  factory :appointment do
    start_date { "2025-10-27 10:00:00 UTC" }
    end_date   { "2025-10-27 11:00:00 UTC" }
    status     { :scheduled }
    provider
    client
  end
end
