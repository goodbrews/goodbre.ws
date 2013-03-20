class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text   :description
      t.string :type

      t.integer :year

      t.date   :start_date
      t.date   :end_date
      t.string :hours
      t.string :price

      t.string :venue
      t.string :street
      t.string :street2
      t.string :city
      t.string :region
      t.string :postal_code
      t.string :country

      t.float :latitude
      t.float :longitude

      t.string :website
      t.string :phone

      t.string :image_id,     limit: 6
      t.string :brewerydb_id, limit: 6
      t.index  :brewerydb_id, unique: true

      t.timestamps
    end

    create_join_table :beers, :events do |t|
      t.index [:beer_id, :event_id], unique: true
    end

    create_join_table :breweries, :events do |t|
      t.index [:brewery_id, :event_id], unique: true
    end
  end
end
