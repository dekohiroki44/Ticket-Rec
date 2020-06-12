FactoryBot.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    agreement { true }
  end
end
