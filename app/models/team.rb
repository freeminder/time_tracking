class Team < ActiveRecord::Base
	has_many :users

  validates :name, presence: true
  validates :name, uniqueness: true, on: :create
end
