require 'net/http'

class Restaurant < ActiveRecord::Base

  validates :name, :city, presence: true
  before_save :yelpify
  acts_as_gmappable validation: false, process_geocoding: false
  geocoded_by :address
  before_save :geocode
  

  def yelpify
    consumer_key = 'Jdy8fp6RC-3uO9eeh1K6IA'
    consumer_secret = 'jfO1O9GH0eMamjUhZZa9byq82ho'
    token = '6_s2AkZmUyYEuwGsJBvkzZlkdiigc7sP'
    token_secret = 'ahhR0jRAKYVyaHBXGamMQCAY3yw'

    api_host = 'api.yelp.com'

    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://api.yelp.com"})
    access_token = OAuth::AccessToken.new(consumer, token, token_secret)

    uri_encoded_name = URI.escape("#{self.name}")
    uri_encoded_city = URI.escape("#{self.city}")
    path = "/v2/search?term=#{uri_encoded_name}&location=#{uri_encoded_city}&limit=5"
    
    #parse API call into JSON object
    res = JSON::parse(access_token.get(path).body)

    self.name = store_restaurants_data(res).first.biz_name
    self.address = store_restaurants_data(res).first.address
    self.state = store_restaurants_data(res).first.state
    self.zip = store_restaurants_data(res).first.zip
    self.yelp_rating = store_restaurants_data(res).first.rating
  end

  #stores salient restaurant data from json feed into hashes within an array within a dream
  def store_restaurants_data(rest_obj)
    my_places = []
    my_place = Struct.new("Place", :biz_name, :rating, :address, :state, :zip) #Defining a new struct (class) called my_place      
    
    rest_obj["businesses"].each do |business|
      new_place = my_place.new
      new_place.biz_name = business["name"]
      new_place.rating = business["rating"]
      new_place.address = "#{business["location"]["address"].join(" ")}, #{business["location"]["state_code"]} #{business["location"]["postal_code"]}"
      new_place.state = business["location"]["state_code"]
      new_place.zip = business["location"]["postal_code"]
      
      my_places << new_place
    end
    my_places
  end
end
