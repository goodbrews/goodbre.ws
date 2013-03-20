# This endpoint has a withBreweries option; it should be run after the Brewery
# endpoint so that we can link up breweries and beers with fewer API requests.

module BreweryDB
  module Synchronizers
    class Event < Base
      protected
        def fetch
          @client.get('/events', p: @page)
        end

        def update!(attributes)
          event = ::Event.find_or_initialize_by(brewerydb_id: attributes['id'])
          event.assign_attributes({
            name:        attributes['name'],
            year:        attributes['year'],
            description: attributes['description'],
            type:        attributes['typeDisplay'],

            start_date:  attributes['startDate'],
            end_date:    attributes['endDate'],
            hours:       attributes['time'],
            price:       attributes['price'],

            venue:       attributes['venueName'],
            street:      attributes['streetAddress'],
            street2:     attributes['extendedAddress'],
            city:        attributes['locality'],
            region:      attributes['region'],
            postal_code: attributes['postalCode'],
            country:     attributes['countryIsoCode'],

            latitude:    attributes['latitude'],
            longitude:   attributes['longitude'],

            website:     attributes['website'],
            phone:       attributes['phone'],

            created_at:  attributes['createDate'],
            updated_at:  attributes['updateDate']
          })

          if attributes['images']
            event.image_id = attributes['images']['icon'].match(/upload_(\w+)-icon/)[0]

          style.save!
        end
    end
  end
end
