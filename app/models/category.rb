class Category < ActiveRecord::Base
  # has_and_belongs_to_many :reports
  # belongs_to :report
  has_many :reports
  # has_many :hours
  has_many :reports, through: :hours
  # accepts_nested_attributes_for :reports
end
