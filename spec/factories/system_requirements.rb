FactoryBot.define do
  factory :system_requirement do
    sequence(:name) { |n| "Basic #{n}" }
    operation_system { Faker::Computer.os }
    storage { "500GB" }
    processor { "INTEL i7" }
    memory { "8GB" }
    video_board { "N/A" }
  end
end
