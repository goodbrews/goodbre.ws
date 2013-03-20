module BreweryDB
  module Synchronizers
    class Location < Base
      protected
        def fetch
          @client.get('/locations', p: @page)
        end

        def update!(attributes)
          location = ::Location.find_or_initialize_by(brewerydb_id: attributes['id'])
          location.assign_attributes({
            name:        attributes['name'],
            type:        attributes['locationTypeDisplay'],
            primary:     attributes['isPrimary'] == 'Y',
            in_planning: attributes['inPlanning'] == 'Y',
            public:      attributes['openToPublic'] == 'Y',
            closed:      attributes['isClosed'] == 'Y',

            street:      attributes['streetAddress'],
            street2:     attributes['extendedAddress'],
            city:        attributes['locality'],
            region:      attributes['region'],
            postal_code: attributes['postalCode'],
            country:     attributes['countryIsoCode'],

            latitude:    attributes['latitude'],
            longitude:   attributes['longitude'],

            phone:       attributes['phone'],
            website:     attributes['website'],
            hours:       attributes['hoursOfOperation'],

            created_at:  attributes['createDate'],
            updated_at:  attributes['updateDate']
          })

          # Associate Brewery
          location.brewery = ::Brewery.find_by_brewerydb_id(attributes['breweryId'])

          location.save!
        end
    end
  end
end
