module BreweryDB
  module Synchronizers
    class Brewery < Base
      private
        def fetch
          @client.get('/breweries', p: @page)
        end

        def update!(attributes)
          brewery = ::Brewery.find_or_initialize_by(brewerydb_id: attributes['id'])
          brewery.assign_attributes({
            name:        attributes['name'],
            website:     attributes['website'],
            description: attributes['description'],
            established: attributes['established'],
            organic:     attributes['isOrganic'] == 'Y' ? true : false,
            
            created_at:  attributes['createDate'],
            updated_at:  attributes['updateDate']
          })
          
          if attributes['images']
            brewery.image_id = attributes['labels']['icon'].match(/upload_(\w+)-icon/)[0]
          end

          beer.save!
        end
    end
  end
end
