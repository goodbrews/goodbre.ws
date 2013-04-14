module BreweryDB
  module Synchronizers
    class Brewery < Base
      def handle_removed!
        ::Brewery.find_each do |brewery|
          response = @client.get("/brewery/#{brewery.brewerydb_id}")

          if response.body['data']['status'] == 'deleted'
            puts "Deleted brewery: #{brewery.name}"
            brewery.destroy
          end
        end
      end

      protected
        def fetch(options = {})
          params = {
            p: @page,
            withSocialAccounts: 'Y',
            withGuilds: 'Y',
            withAlternateNames: 'Y'
          }.merge(options)

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
            brewery.image_id = attributes['images']['icon'].match(/upload_(\w+)-icon/)[1]
          end

          if attributes['alternateNames']
            brewery.alternate_names = attributes['alternateNames'].map { |alt| alt['altName'] }
          end

          if brewery.new_record?
            puts "New brewery: #{brewery.name}"
          end

          brewery.save!

          # Handle social accounts
          Array(attributes['socialAccounts']).each do |account|
            social_account = brewery.social_media_accounts.find_or_initialize_by(website: account['socialMedia']['name'])
            social_account.assign_attributes({
              handle:     account['handle'],
              created_at: account['createDate'],
              updated_at: account['updateDate']
            })

            if social_account.new_record?
              puts "New social account: #{social_account.handle} (for #{brewery.name})"
            end

            social_account.save!
          end

          # Associate guilds
          Array(attributes['guilds']).each do |guild|
            ::Guild.find_by_brewerydb_id(guild['id'])
          end

          brewery.save!
        end

        def destroy!(attributes)
          brewery = ::Brewery.find_by(brewerydb_id: attributes['id'])

          if brewery.present?
            puts "Deleted brewery: #{brewery.name}"
            brewery.destroy
          end
        end
    end
  end
end
