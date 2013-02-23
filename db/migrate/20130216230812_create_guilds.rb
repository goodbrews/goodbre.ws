class CreateGuilds < ActiveRecord::Migration
  def change
    create_table :guilds do |t|
      t.string :name
      t.text   :description
      t.string :website

      t.string :image_id, limit: 6
      t.string :brewerydb_id, limit: 6

      t.integer :established

      t.index :brewerydb_id, unique: true

      t.timestamps
    end

    create_join_table :breweries, :guilds do |t|
      t.index [:brewery_id, :guild_id], unique: true
    end
  end
end
