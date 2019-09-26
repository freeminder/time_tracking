FactoryBot.define do
  factory :hour do
    sunday { Faker::Number.number(1) }
    category { association(:category) }
    report { association(:report) }
  end
end
