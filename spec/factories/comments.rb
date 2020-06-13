FactoryBot.define do
  factory :comment do
    content { "MyString" }
    user
    ticket
  end
end
