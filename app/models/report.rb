class Report < ActiveRecord::Base
  has_and_belongs_to_many :categories

  # has_many :categories_reports
  # has_many :categories, :through => :reports
  belongs_to :user
  # belongs_to :category

  has_many :hours
  accepts_nested_attributes_for :hours
  # serialize :data, Hash
end
