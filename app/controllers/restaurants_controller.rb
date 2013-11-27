require 'net/http'

class RestaurantsController < ApplicationController
  before_filter :authenticate_user!
    
  def home
    @restaurants = Restaurant.find(:all, :conditions => { :user_id => current_user.id })
    @search_zip = params[:zipcode]

    @near_restaurants = Array.new
    # It's OK to do some of this work in the controller. Generally, though, the
    # heavy lifting should be done in the model. The rule of thumb is to have
    # "fat models" and "skinny controllers."
    unless @search_zip.nil?
      @restaurants.each do |restaurant|
        # nice use of imperative programming with `is_in_range`
        if is_in_range?(restaurant, @search_zip)
          @near_restaurants << restaurant
          @hash = Gmaps4rails.build_markers(@near_restaurants) do |restaurant, marker|
            # duplication! Clean this up with a method call...
            meal1, meal2, meal3 = get_meals(restaurant, [0,1,2])
            marker.lat restaurant.latitude
            marker.lng restaurant.longitude
            marker.infowindow "<b>#{restaurant.name}</b><br /> <em>#{restaurant.address}</em> <br /> #{meal1}<br /> #{meal2} <br /> #{meal3}"
          end
        end
      end
    end
  end

  # All of these methods abide by the "skinny controllers" motto and are generally
  # well-put-together
  def index
    @restaurants = Restaurant.find(:all, :conditions => { :user_id => current_user.id })
    @hash = Gmaps4rails.build_markers(@restaurants) do |restaurant, marker|
      marker.lat restaurant.latitude
      marker.lng restaurant.longitude
      marker.infowindow "<b>#{restaurant.name}</b> <br /> <em>#{restaurant.address}</em> <br /> Yelp rating: #{restaurant.yelp_rating}"
    end
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

  def get_meals(restaurant, indices)
    indices.map do |i| 
      restaurant.meals[i].name unless restaurant.meals[i].nil?
    end
  end

  #returns true if location is within 2 miles of zip based on lat/long using geocoder gem
  def is_in_range?(location, zip)
    if Geocoder::Calculations.distance_between(Geocoder.coordinates("#{zip}"), [location.latitude, location.longitude]) <= 0.5
      return true
    else
      return false
    end
  end

  def safe_restaurant_params
    params.require(:restaurant).permit(:name, :address, :yelp_rating, :image_url, :user_id)
  end

  # Yelp code looks like it wants to be its own object. You can store plain old
  # Ruby objects in your lib/ directory and include them at the top of the file.
  #Yelp API call
  def get_yelp_results(name, city)
    consumer_key = ENV["CONSUMER_KEY"]
    consumer_secret = ENV["CONSUMER_SECRET"]
    token = ENV["TOKEN"]
    token_secret = ENV["TOKEN_SECRET"]
    
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
    # What hack told you to use a struct? ;) 
    my_place = Struct.new("Place", :biz_name, :rating, :address, :image_url) #Defining a struct to hold fields from Yelp JSON      
    
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
