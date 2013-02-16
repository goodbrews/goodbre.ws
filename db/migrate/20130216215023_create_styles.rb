class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string  :name
      t.text    :description

      t.float   :min_abv
      t.float   :max_abv
      t.integer :min_ibu
      t.integer :max_ibu
      t.integer :min_original_gravity
      t.integer :max_original_gravity
      t.integer :min_final_gravity
      t.integer :max_final_gravity

      t.string  :permalink,   index: true

      t.references :category, index: true

      t.timestamps
    end
  end
end
