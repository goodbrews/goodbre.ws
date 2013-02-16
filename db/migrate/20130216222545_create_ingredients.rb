class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :name
      t.string :category

      t.timestamps
    end

    create_table :beers_ingredients, id: false do |t|
      t.string     :beer_id, limit: 6
      t.references :ingredient

      t.index [:beer_id, :ingredient_id], unique: true
    end
  end
end
