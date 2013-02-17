class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :email,           null: false
      t.string   :username,        null: false
      t.string   :password_digest, null: false
      t.string   :auth_token

      t.string   :password_reset_token
      t.datetime :password_reset_sent_at

      t.string   :first_name
      t.string   :last_name

      t.string   :city
      t.string   :region
      t.string   :country

      t.index :username, unique: true
      t.index :email,    unique: true

      t.timestamps
    end
  end
end
