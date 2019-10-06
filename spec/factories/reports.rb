# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    user { association(:user) }
  end
end
