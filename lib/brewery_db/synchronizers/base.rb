module BreweryDB
  module Synchronizers
    class Base
      def initializer
        @client = BreweryDB::Client.new
        @page = 1
        @response = fetch_objects
      end

      def synchronize!
        objects.each { |obj| update!(obj) } and next_page! while more_objects?
      end

      private
        def objects() @response['data'] end

        def more_objects?
          @page <= @response['numberOfPages']
        end

        def next_page!
          @page += 1
          @response = fetch
        end

        def fetch
          # Implement in subclasses
        end

        def update!(attributes)
          # Implement in subclasses
        end
    end
  end
end
