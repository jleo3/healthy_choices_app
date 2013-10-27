class Restaurant < ActiveRecord::Base
  geocoded_by :address
  after_validation :geocode
  acts_as_gmappable :process_geocoding => false
end
