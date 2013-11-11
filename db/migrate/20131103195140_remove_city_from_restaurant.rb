class RemoveCityFromRestaurant < ActiveRecord::Migration
  def change
    remove_column :restaurants, :city, :string
  end
end
