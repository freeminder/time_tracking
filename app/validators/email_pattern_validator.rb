# frozen_string_literal: true

# EmailPattern validator
class EmailPatternValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if self.class.valid_value?(value)

    record.errors[attribute] << 'is invalid'
  end

  def self.valid_value?(email)
    return false if email.blank? || email.include?(',')

    EmailAddress.valid?(email)
  end
end
