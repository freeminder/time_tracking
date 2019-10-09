# frozen_string_literal: true

# User model
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable

  belongs_to :team, optional: true
  has_many :reports, dependent: :destroy
  has_many :hours, through: :reports

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            email_pattern: true
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name,  presence: true, length: { minimum: 2 }
  validates :password, confirmation: true, unless: -> { password.blank? }
  validates :rate, presence: true

  def full_name
    ([first_name, last_name] - ['']).compact.join(' ')
  end
end
