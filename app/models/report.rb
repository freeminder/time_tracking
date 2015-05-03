class Report < ActiveRecord::Base
  has_and_belongs_to_many :categories
  belongs_to :user
  # serialize :data, Hash
end
