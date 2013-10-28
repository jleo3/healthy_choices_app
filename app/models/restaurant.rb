class Restaurant < ActiveRecord::Base
  validates :name, :city, presence: true
  acts_as_gmappable :process_geocoding => false
  
end
