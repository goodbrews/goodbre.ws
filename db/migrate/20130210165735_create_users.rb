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

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :email,    unique: true
  end
end
