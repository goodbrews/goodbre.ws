class CreateBeers < ActiveRecord::Migration
  def change
    create_table :beers, id: false do |t|
      t.string  :id, limit: 10
      t.string  :name
      t.float   :abv
      t.integer :ibu
      t.text    :description
      t.string  :availability
      t.string  :glassware
      t.boolean :organic
      t.float   :original_gravity

      t.references :style
      t.string     :image_id, limit: 10

      t.index :permalink, unique: true
      t.index :abv
      t.index :organic

      t.timestamps
    end

    execute 'ALTER TABLE beers ADD PRIMARY KEY (id);'

    create_table :beers_breweries, id: false do |t|
      t.string :beer_id,    limit: 10
      t.string :brewery_id, limit: 10

      t.index [:beer_id, :brewery_id], unique: true
    end
  end
end
