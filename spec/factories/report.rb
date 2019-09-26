FactoryBot.define do
  factory :report do
    user { association(:user) }
  end
end
