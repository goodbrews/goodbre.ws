module BreweryDB
  module Synchronizers
    class Guild < Base
      protected
        def fetch
          params = {
            p: @page,
            withLocations: 'Y',
            withSocialAccounts: 'Y',
            withGuilds: 'Y',
            withAlternateNames: 'Y'
          }

          @client.get('/guilds')
        end

        def update!(attributes)
          guild = ::Guild.find_or_initialize_by(brewerydb_id: attributes['id'])
          guild.assign_attributes({
            name:        attributes['name'],
            description: attributes['description'],
            website:     attributes['website'],
            established: attributes['established'],

            created_at:  attributes['createDate'],
            updated_at:  attributes['updateDate']
          })

          if guild_attributes['images']
            guild.image_id = guild_attributes['images']['icon'].match(/upload_(\w+)-icon/)[0]
          end

          guild.save!
        end
    end
  end
end
