class CreateSocialMediaAccounts < ActiveRecord::Migration
  def change
    create_table :social_media_accounts do |t|
      t.string :website
      t.string :handle

      t.references :socialable, polymorphic: true

      t.index [:socialable_id, :socialable_type], name: 'index_social_media_accounts_on_id_and_type'
      t.index [:socialable_id, :socialable_type, :website], unique: true, name: 'index_unique_social_media_accounts'

      t.timestamps
    end
  end
end
