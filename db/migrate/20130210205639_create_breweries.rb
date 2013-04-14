class CreateBreweries < ActiveRecord::Migration
  def change
    create_table :breweries do |t|
      t.string     :name
      t.string     :alternate_names, array: true
      t.text       :description
      t.string     :website
      t.boolean    :organic
      t.integer    :established

      t.string     :permalink
      t.string     :image_id,     limit: 6
      t.string     :brewerydb_id, limit: 6

      t.index      :permalink,    unique: true
      t.index      :brewerydb_id, unique: true

      t.timestamps
    end
  end
end
