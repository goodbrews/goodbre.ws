class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations, id: false do |t|
      t.string :id, limit: 6

      t.string :name
      t.string :type

      t.boolean :primary
      t.boolean :in_planning
      t.boolean :public
      t.boolean :closed

      t.string :street
      t.string :city
      t.string :region
      t.string :postal_code
      t.string :country

      t.float :latitude
      t.float :longitude

      t.string :website
      t.string :phone

      t.string :brewery_id, limit: 6, index: true

      t.timestamps
    end

    execute 'ALTER TABLE locations ADD PRIMARY KEY (id);'
  end
end
