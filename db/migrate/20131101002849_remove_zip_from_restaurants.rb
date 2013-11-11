class RemoveZipFromRestaurants < ActiveRecord::Migration
  def change
    remove_column :restaurants, :zip, :string
  end
end
