# frozen_string_literal: true

FactoryBot.define do
  factory :hour do
    sunday { Faker::Number.number(digits: 1) }
    category { association(:category) }
    report { association(:report) }
  end
end
