class Brewery < ActiveRecord::Base
  include Permalinkable
  include Socialable

  has_and_belongs_to_many :beers
  has_and_belongs_to_many :guilds
  has_many :locations

  def self.paginate(options = {})
    page(options[:page]).per(options[:per_page])
  end
end
