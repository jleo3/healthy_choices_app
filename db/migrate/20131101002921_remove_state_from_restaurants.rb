class RemoveStateFromRestaurants < ActiveRecord::Migration
  def change
    remove_column :restaurants, :state, :string
  end
end
