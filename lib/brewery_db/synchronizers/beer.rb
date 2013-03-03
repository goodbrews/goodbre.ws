# This endpoint has a withBreweries option; it should be run after the Brewery
# endpoint so that we can link up breweries and beers with fewer API requests.

module BreweryDB
  module Synchronizers
    class Beer < Base
      private
        def fetch
          @client.get('/beers', p: @page, withBreweries: 'Y')
        end

        def update!(attributes)
          beer = ::Beer.find_or_initialize_by(brewerydb_id: attributes['id'])
          beer.assign_attributes({
            name:                attributes['name'],
            description:         attributes['description'],
            abv:                 attributes['abv'],
            ibu:                 attributes['ibu'],
            original_gravity:    attributes['originalGravity'],
            style_id:            attributes['styleId'],
            organic:             attributes['isOrganic'] == 'Y' ? true : false,
            serving_temperature: attributes['servingTemperatureDisplay'],
            availability:        attributes['available'].try(:[], 'name'),
            glassware:           attributes['glass'].try(:[], 'name'),

            created_at:          attributes['createDate'],
            updated_at:          attributes['updateDate']
          })
          
          if attributes['labels']
            beer.image_id = attributes['labels']['icon'].match(/upload_(\w+)-icon/)[0]
          end

          beer.save!

          # Update breweries
          ids = attributes['breweries'].map(&:[], 'id')
          breweries = ::Brewery.where(brewerydb_id: ids).pluck(:id).map(&:id)
          beer.breweries = breweries

          beer.save!
        end
    end
  end
end
