class CreateGuilds < ActiveRecord::Migration
  def change
    create_table :guilds, id: false do |t|
      t.string :id, limit: 6

      t.string :name
      t.text   :description
      t.string :website
      t.string :image_id, limit: 6

      t.integer :established

      t.timestamps
    end

    create_table :breweries_guilds, id: false do |t|
      t.string :brewery_id, limit: 6
      t.string :guild_id,   limit: 6

      t.index [:brewery_id, :guild_id], unique: true
    end
  end
end
