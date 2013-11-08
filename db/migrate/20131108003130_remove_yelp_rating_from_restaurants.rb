class RemoveYelpRatingFromRestaurants < ActiveRecord::Migration
  def change
    remove_column :restaurants, :yelp_rating, :integer
  end
end
