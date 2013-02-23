class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :name
      t.string :category

      t.timestamps
    end

    create_join_table :beers, :ingredients do |t|
      t.index [:beer_id, :ingredient_id], unique: true
    end
  end
end
