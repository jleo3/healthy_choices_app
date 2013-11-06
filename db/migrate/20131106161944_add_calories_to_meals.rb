class AddCaloriesToMeals < ActiveRecord::Migration
  def change
    add_column :meals, :calories, :integer
  end
end
