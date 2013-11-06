class RemoveUserIdFromMeals < ActiveRecord::Migration
  def change
    remove_column :meals, :user_id, :string
  end
end
