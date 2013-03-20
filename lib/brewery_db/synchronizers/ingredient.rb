module BreweryDB
  module Synchronizers
    class Ingredient < Base
      protected
        def fetch
          @client.get('/ingredients', p: @page)
        end

        def update!(attributes)
          ingredient = ::Ingredient.find_or_initialize_by(id: attributes['id'])
          ingredient.assign_attributes({
            name:        attributes['name'],
            category:    attributes['categoryDisplay'],

            created_at:  attributes['createDate'],
            updated_at:  attributes['updateDate']
          })

          ingredient.save!
        end
    end
  end
end
