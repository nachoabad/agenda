class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :services
  has_many :events
  has_many :event_rules
  has_many :payments, through: :events

  # TODO: add custom timezones hash
  before_save :fix_time_zones

  def owns?(object)
    object.user_id == id
  end

  private

  # TODO: add custom timezones hash
  def fix_time_zones
    self.time_zone = "Central America" if time_zone == "Mexico City"
  end
end
