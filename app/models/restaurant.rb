class Restaurant < ActiveRecord::Base
  acts_as_gmappable :process_geocoding => false
end
