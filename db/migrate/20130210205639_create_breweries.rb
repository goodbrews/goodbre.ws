class CreateBreweries < ActiveRecord::Migration
  def change
    create_table :breweries, id: false do |t|
      t.string     :id, limit: 6
      t.string     :name
      t.text       :description
      t.string     :website
      t.boolean    :organic

      t.string     :permalink
      t.string     :image_id, limit: 6

      t.index      :permalink, unique: true

      t.timestamps
    end

    execute 'ALTER TABLE breweries ADD PRIMARY KEY (id);'
  end
end
