# This endpoint has a withBreweries option; it should be run after the Brewery
# endpoint so that we can link up breweries and beers with fewer API requests.

module BreweryDB
  module Synchronizers
    class Beer < Base
      protected
        def fetch
          params = {
            p: @page,
            withBreweries: 'Y',
            withSocialAccounts: 'Y',
            withIngredients: 'Y'
          }
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
    end
  end
end
