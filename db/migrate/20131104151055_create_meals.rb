class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.string :name
      t.string :description
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
