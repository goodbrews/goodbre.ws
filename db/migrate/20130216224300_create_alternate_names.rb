class CreateAlternateNames < ActiveRecord::Migration
  def change
    create_table :alternate_names do |t|
      t.references :brewery, index: true
      t.string :name

      t.timestamps
    end
  end
end
