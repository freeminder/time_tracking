class Category < ActiveRecord::Base
  # has_many :reports
  has_many :reports, through: :hours
end
