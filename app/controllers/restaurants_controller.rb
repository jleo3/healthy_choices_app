class RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant.all
    @json = @restaurants.to_gmaps4rails
  end

  def new
    restaurant_search = Struct.new("Restaurant_Search", :name, :city) #Struct for user restaurant search to match against Yelp query
    @new_search = restaurant_search.new
    @yelp_results = get_yelp_query(@new_search)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def create
    @restaurant = Restaurant.new(safe_restaurant_params)
    if @restaurant.save
      redirect_to @restaurant
    else
      render :new
    end
  end

  private

  def safe_restaurant_params
    params.require('restaurant').permit(:name, :city)
  end

  def get_yelp_query(search_obj)
    consumer_key = 'Jdy8fp6RC-3uO9eeh1K6IA'
    consumer_secret = 'jfO1O9GH0eMamjUhZZa9byq82ho'
    token = '6_s2AkZmUyYEuwGsJBvkzZlkdiigc7sP'
    token_secret = 'ahhR0jRAKYVyaHBXGamMQCAY3yw'

    api_host = 'api.yelp.com'

    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://api.yelp.com"})
    access_token = OAuth::AccessToken.new(consumer, token, token_secret)

    uri_encoded_name = URI.escape("#{search_obj.name}")
    uri_encoded_city = URI.escape("#{search_obj.city}")
    path = "/v2/search?term=#{uri_encoded_name}&location=#{uri_encoded_city}&limit=5"

    #parse API call into JSON object
    res = JSON::parse(access_token.get(path).body)

    name = store_restaurants_data(res).first.biz_name
    address = store_restaurants_data(res).first.address
    yelp_rating = store_restaurants_data(res).first.rating

    [name, address, yelp_rating]
  end
  
  def store_restaurants_data(rest_obj)
    my_places = []
    my_place = Struct.new("Place", :biz_name, :rating, :address) #Defining a new struct (class) called my_place      
    
    rest_obj["businesses"].each do |business|
      new_place = my_place.new
      new_place.biz_name = business["name"]
      new_place.rating = business["rating"]
      new_place.address = "#{business["location"]["address"].join(" ")}, #{business["location"]["state_code"]} #{business["location"]["postal_code"]}"
           
      my_places << new_place
    end
    my_places
  end

end
