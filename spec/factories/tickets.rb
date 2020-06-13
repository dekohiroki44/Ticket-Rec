FactoryBot.define do
  factory :ticket do
    date { Date.current }
    done { false }
    public { true }
    user
  end
end
