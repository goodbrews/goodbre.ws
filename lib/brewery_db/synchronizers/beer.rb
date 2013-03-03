module BreweryDB
  module Synchronizers
    class Beer
      def initializer
        @client = BreweryDB::Client.new
        @page = 1
        @response = fetch_beers
      end

      def synchronize!
        beers.each { |beer| update!(beer) } and next_page! while more_beers?
      end

      private
        def beers() @response['data'] end

        def more_beers?
          @page <= @response['numberOfPages']
        end

        def next_page!
          @page += 1
          @response = fetch_beers
        end

        def fetch_beers
          @client.get('/beers', p: @page)
        end

        def update!(attributes)
          beer = ::Beer.find_or_initialize_by(brewerydb_id: attributes['id'])
          beer.update_attributes({
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
        end
    end
  end
end
