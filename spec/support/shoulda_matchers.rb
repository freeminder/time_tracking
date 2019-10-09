# frozen_string_literal: true

Shoulda::Matchers.configure do |matchers|
  matchers.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
