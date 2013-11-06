class MealsController < ApplicationController

  def new
    @meal = Meal.new
    @restaurant_id = params[:rest_id]
    @user_id = params[:user_id]
  end

  def show

  end
  
  def create
    @meal = Meal.new(safe_meal_params)
    if @meal.save
      redirect_to @meal
    else
      render :new
    end
  end
  
  private
  
  def safe_meal_params
    params.require(:meal).permit(:name, :description, :restaurant_id, :user_id)
  end

end
