class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events, id: false do |t|
      t.string :id, limit: 6

      t.string :name
      t.text   :description
      t.string :type

      t.integer :year

      t.date   :start_date
      t.date   :end_date
      t.string :hours
      t.string :price

      t.string :image_id, limit: 6

      t.string :venue
      t.string :street
      t.string :city
      t.string :region
      t.string :postal_code
      t.string :country

      t.float :latitude
      t.float :longitude

      t.string :website
      t.string :phone

      t.timestamps
    end

    execute 'ALTER TABLE events ADD PRIMARY KEY (id);'

    create_table :beers_events, id: false do |t|
      t.string :beer_id,  limit: 6
      t.string :event_id, limit: 6

      t.index [:beer_id, :event_id], unique: true
    end

    create_table :breweries_events, id: false do |t|
      t.string :brewery_id, limit: 6
      t.string :event_id,   limit: 6

      t.index [:brewery_id, :event_id], unique: true
    end
  end
end
