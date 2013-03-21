class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :category

      t.boolean :primary
      t.boolean :in_planning
      t.boolean :public
      t.boolean :closed

      t.string :street
      t.string :street2
      t.string :city
      t.string :region
      t.string :postal_code
      t.string :country

      t.float :latitude
      t.float :longitude

      t.text  :hours
      t.string :website
      t.string :phone

      t.references :brewery,  index: true
      t.string :brewerydb_id, limit: 6

      t.index :brewerydb_id, unique: true

      t.timestamps
    end
  end
end
