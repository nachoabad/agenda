class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :services
  has_many :events
  has_many :event_rules
  has_many :payments, through: :events

  def owns?(service)
    service.user_id == id
  end
end
