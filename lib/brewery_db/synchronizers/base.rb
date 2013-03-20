module BreweryDB
  module Synchronizers
    class Base
      def initialize
        @client = BreweryDB::Client.new
        @page = 1
        @response = fetch
        @pages = @response.body['numberOfPages'] || 1
      end

      def synchronize!
        objects.each { |obj| update!(obj) } and next_page! while more_objects?
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

        def fetch
          # Implement in subclasses
        end

        def update!(attributes)
          # Implement in subclasses
        end
    end
  end
end
