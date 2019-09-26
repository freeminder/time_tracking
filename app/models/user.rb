class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  belongs_to :team
  has_many :reports, dependent: :destroy
  has_many :hours, through: :reports

  validates :email, :first_name, :last_name, :rate, presence: true
  validates :first_name, length: { minimum: 2 }
  validates :last_name, length: { minimum: 2 }
  validates :email, uniqueness: true, on: :create
  validates :email, format: { :with => Devise::email_regexp }
  validates :password, length: { in: 8..128 }
  validates :password, confirmation: true, unless: -> { password.blank? }

  def full_name
    ([first_name, last_name] - ['']).compact.join(' ')
  end
end
