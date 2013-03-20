class CreateSocialMediaAccounts < ActiveRecord::Migration
  def change
    create_table :social_media_accounts do |t|
      t.string :site
      t.string :handle

      t.references :socialable, polymorphic: true

      t.index [:socialable_id, :socialable_type], unique: true, name: 'index_social_media_accounts_on_id_and_type'

      t.timestamps
    end
  end
end
