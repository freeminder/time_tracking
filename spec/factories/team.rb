FactoryBot.define do
  factory :team do
    name { Faker::Commerce.department }
  end
end
