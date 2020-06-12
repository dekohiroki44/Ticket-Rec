FactoryBot.define do
  factory :ticket do
    user { nil }
    date { Date.current }
    public { true }
    done { false }
  end
end
