class Category < ActiveRecord::Base
  has_many :hours, dependent: :delete_all
  has_many :reports, through: :hours

  validates :name, presence: true
  validates :name, uniqueness: true, on: :create
end
