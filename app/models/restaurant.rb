class Restaurant < ActiveRecord::Base

  validates :name, :address, presence: true
  acts_as_gmappable validation: false, process_geocoding: false
  geocoded_by :address
  before_save :geocode
    
end
