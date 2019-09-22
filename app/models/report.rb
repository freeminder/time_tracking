class Report < ActiveRecord::Base
  belongs_to :user
  has_many :hours, dependent: :delete_all
  accepts_nested_attributes_for :hours
  has_many :categories, through: :hours

  validates :user, presence: :true, on: [:create, :update]
end
