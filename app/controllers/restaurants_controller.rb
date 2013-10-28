class RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant.all
    @json = @restaurants.to_gmaps4rails
    
  end

  def new
    @restaurant = Restaurant.new
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @restaurant_array = Restaurant.get_google_places(@restaurant)
    
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
    params.require('restaurant').permit(:name, :longitude, :latitude, :address)
  end
end
