class Category < ActiveRecord::Base
  has_many :hours, dependent: :delete_all
  has_many :reports, through: :hours
end
