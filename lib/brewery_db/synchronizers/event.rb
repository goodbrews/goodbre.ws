# This endpoint has a withBreweries option; it should be run after the Brewery
# endpoint so that we can link up breweries and beers with fewer API requests.

module BreweryDB
  module Synchronizers
    class Event < Base
      def handle_removed!
        ::Event.find_each do |event|
          response = @client.get("/event/#{event.brewerydb_id}")

          if response.body['data']['status'] == 'deleted'
            puts "Deleted event: #{event.name}"
            event.destroy
          end
        end
      end

      protected
        def fetch(options = {})
          params = { p: @page }.merge(options)
          @client.get('/events', params)
        end

        def update!(attributes)
          event = ::Event.find_or_initialize_by(brewerydb_id: attributes['id'])

          event.assign_attributes({
            name:        attributes['name'],
            year:        attributes['year'],
            description: attributes['description'],
            category:    attributes['typeDisplay'],

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
            event.image_id = attributes['images']['icon'].match(/upload_(\w+)-icon/)[1]
          end

          if event.new_record?
            puts "New event: #{event.name}"
          end

          event.save!
        end

        def destroy!(attributes)
          event = ::Event.find_by(brewerydb_id: attributes['id'])

          if event.present?
            puts "Deleted event: #{event.name}"
            event.destroy
          end
        end
    end
  end
end
