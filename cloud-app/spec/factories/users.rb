FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_#{n}" }
    balance { 0.0 }
  end
end