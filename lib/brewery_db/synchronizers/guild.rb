module BreweryDB
  module Synchronizers
    class Guild < Base
      def handle_removed!
        ::Guild.find_each do |guild|
          response = @client.get("/guild/#{guild.brewerydb_id}")

          if response.body['data']['status'] == 'deleted'
            puts "Deleted guild: #{guild.name}"
            guild.destroy
          end
        end
      end

      protected
        def fetch(options = {})
          params = { p: @page }.merge(options)

          @client.get('/guilds', params)
        end

        def update!(attributes)
          guild = ::Guild.find_or_initialize_by(brewerydb_id: attributes['id'])

          guild.assign_attributes({
            name:        attributes['name'],
            description: attributes['description'],
            website:     attributes['website'],
            established: attributes['established'],

            created_at:  attributes['createDate'],
            updated_at:  attributes['updateDate']
          })

          if attributes['images']
            guild.image_id = attributes['images']['icon'].match(/upload_(\w+)-icon/)[1]
          end

          if guild.new_record?
            puts "New guild: #{guild.name}"
          end

          guild.save!
        end

        def destroy!(attributes)
          guild = ::Guild.find_by(brewerydb_id: attributes['id'])

          if guild.present?
            puts "Deleted guild: #{guild.name}"
            guild.destroy
          end
        end
    end
  end
end
