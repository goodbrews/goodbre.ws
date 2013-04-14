# This endpoint has a withBreweries option; it should be run after the Brewery
# endpoint so that we can link up breweries and beers with fewer API requests.

module BreweryDB
  module Synchronizers
    class Beer < Base
      def handle_removed!
        ::Beer.find_each do |beer|
          response = @client.get("/beer/#{beer.brewerydb_id}")

          if response.body['data']['status'] == 'deleted'
            puts "Deleted beer: #{beer.name} (by #{beer.breweries.map(&:name).to_sentence})"
            beer.destroy
          end
        end
      end

      protected
        def fetch(options = {})
          params = {
            p: @page,
            withBreweries: 'Y',
            withSocialAccounts: 'Y',
            withIngredients: 'Y'
          }.merge(options)

          @client.get('/beers', params)
        end

        def update!(attributes)
          beer = ::Beer.find_or_initialize_by(brewerydb_id: attributes['id'])

          beer.assign_attributes({
            name:                attributes['name'],
            description:         attributes['description'],
            abv:                 attributes['abv'],
            ibu:                 attributes['ibu'],
            original_gravity:    attributes['originalGravity'],
            organic:             attributes['isOrganic'] == 'Y',
            serving_temperature: attributes['servingTemperatureDisplay'],
            availability:        attributes['available'].try(:[], 'name'),
            glassware:           attributes['glass'].try(:[], 'name'),

            created_at:          attributes['createDate'],
            updated_at:          attributes['updateDate']
          })

          if attributes['labels']
            beer.image_id = attributes['labels']['icon'].match(/upload_(\w+)-icon/)[1]
          end

          if beer.new_record?
            brewery_names = Array(attributes['breweries']).map { |b| b['name'] }
            puts "New beer: #{beer.name} (by #{brewery_names.to_sentence})"
          end

          beer.save!

          # Assign Breweries
          breweries = Array(attributes['breweries']).map do |brewery|
            ::Brewery.find_by(brewerydb_id: brewery['id'])
          end
          beer.breweries = breweries.compact.uniq

          # Assign Style
          beer.style = ::Style.find(attributes['styleId']) if attributes['styleId']

          # Handle Social Accounts
          Array(attributes['socialAccounts']).each do |account|
            social_account = beer.social_media_accounts.find_or_initialize_by(website: account['socialMedia']['name'])
            social_account.assign_attributes({
              handle:     account['handle'],
              created_at: account['createDate']
            })

            if social_account.new_record?
              puts "New social account: #{social_account.handle} (for #{beer.name})"
            end

            social_account.save!
          end

          # Handle Ingredients
          if attributes['ingredients']
            beer.ingredients = attributes['ingredients'].flat_map { |_, i| i }.map do |ingredient|
              ::Ingredient.find(ingredient['id'])
            end
          end

          beer.save!
        end

        def destroy!(attributes)
          beer = ::Beer.find_by(brewerydb_id: attributes['id'])

          if beer.present?
            puts "Deleted beer: #{beer.name} (by #{beer.breweries.map(&:name).to_sentence})"
            beer.destroy
          end
        end
    end
  end
end
