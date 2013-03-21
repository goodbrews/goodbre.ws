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
  task :synchronize => :environment do
    # puts "Synchronizing ingredients..."
    # ingredients = BreweryDB::Synchronizers::Ingredient.new
    # ingredients.synchronize!

    # puts "Synchronizing events..."
    # events = BreweryDB::Synchronizers::Event.new
    # events.synchronize!

    # puts "Synchronizing guilds..."
    # guilds = BreweryDB::Synchronizers::Guild.new
    # guilds.synchronize!

    # puts "Synchronizing breweries..."
    # breweries = BreweryDB::Synchronizers::Brewery.new
    # breweries.synchronize!

    # puts "Synchronizing styles..."
    # styles = BreweryDB::Synchronizers::Style.new
    # styles.synchronize!

    # puts "Synchronizing beers..."
    # beers = BreweryDB::Synchronizers::Beer.new
    # beers.synchronize!

    puts "Synchronizing locations..."
    locations = BreweryDB::Synchronizers::Location.new
    locations.synchronize!
  end
end
