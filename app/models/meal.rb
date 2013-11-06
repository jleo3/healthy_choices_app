class Meal < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :user
  
  validates :name, :description, presence: true
  validates :calories, numericality: true, :allow_nil => true
end
