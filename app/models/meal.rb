class Meal < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :user
  
  validates :name, :description, presence: true
end
