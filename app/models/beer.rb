class Beer < ActiveRecord::Base
  include Permalinkable

  has_many   :breweries
  belongs_to :style

  def self.paginate(options = {})
    page(options[:page]).per(options[:per_page])
  end
end
