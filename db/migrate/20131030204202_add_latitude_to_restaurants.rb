class AddLatitudeToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :latitude, :float
  end
end
