module BreweryDB
  module Synchronizers
    class Brewery < Base
      protected
        def fetch
          params = {
            p: @page,
            withLocations: 'Y',
            withSocialAccounts: 'Y',
            withGuilds: 'Y',
            withAlternateNames: 'Y'
          }

          @client.get('/breweries', params)
        end

        def update!(attributes)
          brewery = ::Brewery.find_or_initialize_by(brewerydb_id: attributes['id'])
          brewery.assign_attributes({
            name:        attributes['name'],
            website:     attributes['website'],
            description: attributes['description'],
            established: attributes['established'],
            organic:     attributes['isOrganic'] == 'Y',
            
            created_at:  attributes['createDate'],
            updated_at:  attributes['updateDate']
          })
          
          if attributes['images']
            brewery.image_id = attributes['labels']['icon'].match(/upload_(\w+)-icon/)[0]
          end

          if attributes['alternateNames']
            brewery.alternate_name = attributes['alternateNames'].first['altName']
          end

          # Handle social accounts
          Array(attributes['socialAccounts']).each do |account|
            social_account = brewery.social_media_accounts.find_or_initialize_by(website: account['socialMedia']['name'])
            social_account.assign_attributes({
              handle:     account['handle'],
              created_at: account['createDate']
            })

            social_account.save!
          end

          # Associate guilds
          Array(attributes['guilds']).each do |guild|
            brewery.guilds << ::Guild.find_by_brewerydb_id(guild['id'])
          end

          brewery.save!
        end
    end
  end
end
