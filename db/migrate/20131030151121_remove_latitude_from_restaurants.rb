class RemoveLatitudeFromRestaurants < ActiveRecord::Migration
  def change
    remove_column :restaurants, :latitude, :float
  end
end
