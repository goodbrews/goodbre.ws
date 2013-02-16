class Brewery < ActiveRecord::Base
  include Permalinkable
  has_many :beers
  has_many :locations
  has_and_belongs_to_many :guilds

  def self.paginate(options = {})
    page(options[:page]).per(options[:per_page])
  end
end
