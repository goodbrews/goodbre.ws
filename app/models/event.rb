class Event < ActiveRecord::Base
  has_and_belongs_to_many :beers
  has_and_belongs_to_many :breweries

  before_destroy { beers.clear and breweries.clear }
end
