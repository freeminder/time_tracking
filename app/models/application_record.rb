# frozen_string_literal: true

# Application base model
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
