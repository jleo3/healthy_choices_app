require 'net/http'

class RestaurantsController < ApplicationController
    
  def index
    @restaurants = Restaurant.all
    @json = @restaurants.to_gmaps4rails
  end

  def search
    @search_name = params[:name]
    @search_city = params[:city]
    
    unless @search_name.nil? && @search_city.nil?
      redirect_to :action => "new", :name => @search_name, :city => @search_city
    end
  end
  
  def new
    @restaurant_results = get_yelp_results(params[:name], params[:city])
    @restaurant = Restaurant.new
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
    params.require(:restaurant).permit(:name, :address, :yelp_rating)
  end

  def get_yelp_results(name, city)
    consumer_key = 'Jdy8fp6RC-3uO9eeh1K6IA'
    consumer_secret = 'jfO1O9GH0eMamjUhZZa9byq82ho'
    token = '6_s2AkZmUyYEuwGsJBvkzZlkdiigc7sP'
    token_secret = 'ahhR0jRAKYVyaHBXGamMQCAY3yw'
    
    api_host = 'api.yelp.com'
    
    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://api.yelp.com"})
    access_token = OAuth::AccessToken.new(consumer, token, token_secret)
    
    uri_name = URI.escape("#{name}")
    uri_city = URI.escape("#{city}")
    
    path = "/v2/search?term=#{uri_name}&location=#{uri_city}&limit=5"

    #parse API call into JSON object
    res = JSON::parse(access_token.get(path).body)
    store_restaurants_data(res)
  end
  
  def store_restaurants_data(rest_obj)
    my_places = []
    my_place = Struct.new("Place", :biz_name, :rating, :address, :image_url) #Defining a new struct (class) to hold fields from Yelp JSON      
    
    rest_obj["businesses"].each do |business|
      new_place = my_place.new
      new_place.biz_name = business["name"]
      new_place.rating = business["rating"]
      new_place.address = "#{business["location"]["address"].join(" ")}, #{business["location"]["state_code"]} #{business["location"]["postal_code"]}"
      new_place.image_url = business["image_url"]

      my_places << new_place
    end
    my_places
  end
end
