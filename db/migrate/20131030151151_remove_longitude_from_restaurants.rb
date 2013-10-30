class RemoveLongitudeFromRestaurants < ActiveRecord::Migration
  def change
    remove_column :restaurants, :longitude, :float
  end
end
