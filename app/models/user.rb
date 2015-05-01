class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :team
  # has_one :report, dependent: :destroy
  # has_many :reports, dependent: :delete_all
  # has_many :categories, dependent: :delete_all


end
