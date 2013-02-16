class CreateAlternateNames < ActiveRecord::Migration
  def change
    create_table :alternate_names do |t|
      t.string :brewery_id, limit: 6, index: true
      t.string :name

      t.timestamps
    end
  end
end
