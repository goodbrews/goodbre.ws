class CreateBeers < ActiveRecord::Migration
  def change
    create_table :beers do |t|
      t.string  :name
      t.float   :abv
      t.integer :ibu
      t.text    :description
      t.string  :availability
      t.string  :glassware
      t.boolean :organic
      t.float   :original_gravity
      t.float   :serving_temperature
      t.string  :permalink

      t.string     :brewerydb_id, limit: 6
      t.string     :image_id,     limit: 6
      t.references :style,        index: true

      t.index :brewerydb_id,      unique: true
      t.index :permalink,         unique: true
      t.index :organic

      t.timestamps
    end

    create_join_table :beers, :breweries do |t|
      t.index [:beer_id, :brewery_id], unique: true
    end
  end
end
