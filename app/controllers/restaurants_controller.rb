class RestaurantsController < ApplicationController
    
  def index
    @restaurants = Restaurant.all
    @json = @restaurants.to_gmaps4rails
  end

  def search
    
  end
  
  def new
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
    params.require('restaurant').permit(:name, :city)
  end
end
