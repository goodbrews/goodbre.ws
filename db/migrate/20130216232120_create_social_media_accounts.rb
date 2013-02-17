class CreateSocialMediaAccounts < ActiveRecord::Migration
  def change
    create_table :social_media_accounts do |t|
      t.string :site
      t.string :handle

      t.string :socialable_id, limit: 6
      t.string :socialable_type

      t.index [:socialable_id, :socialable_type], unique: true

      t.timestamps
    end
  end
end
