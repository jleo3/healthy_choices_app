class AddYelpRatingToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :yelp_rating, :integer
  end
end
