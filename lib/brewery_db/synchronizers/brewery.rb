module BreweryDB
  module Synchronizers
    class Brewery < Base
      private
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

          brewery.save!

          # Handle locations
          Array(attributes['locations']).each do |location_attributes|
            location = brewery.locations.find_or_initialize_by(brewerydb_id: location_attributes['id'])
            location.assign_attributes({
              name:        location_attributes['name'],
              type:        location_attributes['locationTypeDisplay'],
              primary:     location_attributes['isPrimary'] == 'Y',
              in_planning: location_attributes['inPlanning'] == 'Y',
              public:      location_attributes['openToPublic'] == 'Y',
              closed:      location_attributes['isClosed'] == 'Y',

              street:      location_attributes['streetAddress'],
              street2:     location_attributes['extendedAddress'],
              city:        location_attributes['locality'],
              region:      location_attributes['region'],
              postal_code: location_attributes['postalCode'],
              country:     location_attributes['countryIsoCode'],

              latitude:    location_attributes['latitude'],
              longitude:   location_attributes['longitude'],

              phone:       location_attributes['phone'],
              website:     location_attributes['website'],
              hours:       location_attributes['hoursOfOperation'],

              created_at:  location_attributes['createDate'],
              updated_at:  location_attributes['updateDate']
            })

            location.save!
          end

          # Handle social accounts
          Array(attributes['socialAccounts']).each do |social_attributes|
            social_account = brewery.social_media_accounts.find_or_initialize_by(website: social_attributes['socialMedia']['name'])
            social_account.assign_attributes({
              handle:     social_attributes['handle'],
              created_at: social_attributes['createDate']
            })

            social_account.save!
          end

          # Handle guilds
          Array(attributes['guilds']).each do |guild_attributes|
            guild = brewery.guilds.find_or_initialize_by(brewerydb_id: guild_attributes['id'])
            guild.assign_attributes({
              name:        guild_attributes['name'],
              description: guild_attributes['description'],
              website:     guild_attributes['website'],
              established: guild_attributes['established'],

              created_at:  guild_attributes['createDate'],
              updated_at:  guild_attributes['updateDate']
            })

            if guild_attributes['images']
              guild.image_id = guild_attributes['images']['icon'].match(/upload_(\w+)-icon/)[0]
            end
          end

          # Handle alternate names
          Array(attributes['alternateNames']).each do |alternate|
            alt_name = brewery.alternate_names.find_or_initialize_by(name: alternate['altName'])
            alt_name.save!
          end

          brewery.save!
        end
    end
  end
end
