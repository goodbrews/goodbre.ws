# This endpoint has a withBreweries option; it should be run after the Brewery
# endpoint so that we can link up breweries and beers with fewer API requests.

module BreweryDB
  module Synchronizers
    class Style < Base
      protected
        def fetch(options = {})
          @client.get('/styles')
        end

        def update!(attributes)
          style = ::Style.find_or_initialize_by(id: attributes['id'])
          style.assign_attributes({
            name:        attributes['name'],
            category:    attributes['category']['name'],
            description: attributes['description'],

            min_ibu:              attributes['ibuMin'],
            max_ibu:              attributes['ibuMax'],
            min_abv:              attributes['abvMin'],
            max_abv:              attributes['abvMax'],
            min_original_gravity: attributes['ogMin'],
            max_original_gravity: attributes['ogMax'],
            min_final_gravity:    attributes['fgMin'],
            max_final_gravity:    attributes['fgMax'],

            created_at:  attributes['createDate'],
            updated_at:  attributes['updateDate']
          })

          if style.new_record?
            puts "New style: #{style.name}"
          end

          style.save!
        end
    end
  end
end
