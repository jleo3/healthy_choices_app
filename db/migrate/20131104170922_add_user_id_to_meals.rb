class AddUserIdToMeals < ActiveRecord::Migration
  def change
    add_column :meals, :user_id, :string
  end
end
