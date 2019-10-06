# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { "#{Faker::Name.first_name}.#{Faker::Name.last_name}@myexample.com" }
    password { Faker::Internet.password(8, 128) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    team { association(:team) }
  end
end
