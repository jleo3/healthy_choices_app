class Restaurant < ActiveRecord::Base
  has_many :meals
  belongs_to :restaurant
  belongs_to :user

  validates :name, :address, presence: true
  geocoded_by :address
  before_save :geocode
end
