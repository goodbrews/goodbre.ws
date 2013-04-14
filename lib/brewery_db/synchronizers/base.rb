module BreweryDB
  module Synchronizers
    class Base
      def initialize
        @client = BreweryDB::Client.new
      end

      def synchronize!
        @page = 1
        @response = fetch
        @pages = @response.body['numberOfPages'] || 1

        objects.each { |obj| update!(obj) } and next_page! while more_objects?
      end

      def remove_deleted!
        @response = fetch(status: 'deleted')
        @page = 1
        @pages = @response.body['numberOfPages'] || 1

        objects.each { |obj| destroy!(obj) } and next_page! while more_objects?
      end

      protected
        def objects() @response.body['data'] end

        def more_objects?
          @page <= @pages
        end

        def next_page!
          @page += 1
          @response = fetch unless @page > @pages
          true
        end

        def fetch(options = {})
          # Implement in subclasses
        end

        def update!(attributes)
          # Implement in subclasses
        end

        def destroy!(attributes)
          # Implement in subclasses
        end
    end
  end
end
