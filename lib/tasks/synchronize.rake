require 'brewery_db/client'
require 'brewery_db/synchronizers/base'
require 'brewery_db/synchronizers/beer'
require 'brewery_db/synchronizers/brewery'
require 'brewery_db/synchronizers/event'
require 'brewery_db/synchronizers/guild'
require 'brewery_db/synchronizers/ingredient'
require 'brewery_db/synchronizers/location'
require 'brewery_db/synchronizers/style'

namespace :brewery_db do
  namespace :synchronize do
    things = %w[ingredients events guilds breweries styles beers locations].map(&:to_sym)

    things.each do |thing|
      desc "Synchronizes #{thing} with BreweryDB's data. Adds, updates, and removes as necessary."
      task thing => :environment do
        puts "Synchronizing #{thing}..."
        klass = "brewery_d_b/synchronizers/#{thing}".classify.constantize

        synchronizer = klass.new
        synchronizer.synchronize!
        synchronizer.handle_removed! unless thing.in?([:ingredients, :styles])
      end
    end

    desc 'Synchronizes all data with BreweryDB. Adds, updates, and removes as necessary.'
    task :all => things
  end
end
