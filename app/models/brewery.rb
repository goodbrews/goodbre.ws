class Brewery < ActiveRecord::Base
  include Permalinkable
  include Socialable

  has_and_belongs_to_many :beers
  has_and_belongs_to_many :guilds
  has_many :locations, dependent: :destroy

  before_destroy { beers.clear and guilds.clear }

  def self.paginate(options = {})
    page(options[:page]).per(options[:per_page])
  end
end
