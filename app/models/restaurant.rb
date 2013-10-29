require 'net/http'

class Restaurant < ActiveRecord::Base

  validates :name, :city, presence: true
  acts_as_gmappable :process_geocoding => false
  before_save :yelpify
  
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
    path = "/v2/search?term=#{uri_encoded_name}&location=#{uri_encoded_city}&limit=1&category_filter=restaurants"
    

    res = JSON::parse(access_token.get(path).body)
    self.address = res

  end
end
