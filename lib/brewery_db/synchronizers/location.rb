module BreweryDB
  module Synchronizers
    class Location < Base
      def handle_removed!
        ::Location.find_each do |location|
          response = @client.get("/location/#{location.brewerydb_id}")

          if response.body['data']['status'] == 'deleted'
            puts "Deleted location: #{location.name}"
            location.destroy
          end
        end
      end

      protected
        def fetch(options = {})
          params = { p: @page }.merge(options)
          @client.get('/locations', params)
        end

        def update!(attributes)
          location = ::Location.find_or_initialize_by(brewerydb_id: attributes['id'])

          location.assign_attributes({
            name:        attributes['name'],
            category:    attributes['locationTypeDisplay'],
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

          if location.new_record?
            puts "New location: #{location.name} (for #{location.brewery.name})"
          end

          location.save!
        end

        def destroy!(attributes)
          location = ::Location.find_by(brewerydb_id: attributes['id'])

          if location.present?
            puts "Deleted location: #{location.name}"
            location.destroy
          end
        end
    end
  end
end
