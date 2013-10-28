class Restaurant < ActiveRecord::Base
  geocoded_by :address
  after_validation :geocode
  acts_as_gmappable :process_geocoding => false


  def self.get_google_places(restaurant)
    @client = GooglePlaces::Client.new('AIzaSyCKQ1sBI9xkbkB4KxF8tuoIoHAhmEzhCAg')
    @restaurant_array = @client.spots(restaurant.latitude, restaurant.longitude, :types => ['food'], :radius => 20000, :name => 'Carnegie Deli')
  end
end
