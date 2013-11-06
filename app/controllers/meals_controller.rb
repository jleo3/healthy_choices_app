class MealsController < ApplicationController

  def new
    @meal = Meal.new
    @restaurant_id = params[:rest_id]
    @user_id = params[:user_id]
  end
  
  def create
    @meal = Meal.new(safe_meal_params)
    if @meal.save
      redirect_to restaurant_path(@meal.restaurant_id)
    else
      render :new
    end
  end
  
  def edit
    @meal = Meal.find(params[:id])
  end

  def update
    @meal = Meal.find(params[:id])
    if @meal.update_attributes(safe_meal_params)
      redirect_to restaurant_path(@meal.restaurant_id)
    else
      render :edit
    end
  end

  private
  
  def safe_meal_params
    params.require(:meal).permit(:name, :description, :restaurant_id, :user_id, :calories)
  end

end
