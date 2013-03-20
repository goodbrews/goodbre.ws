class Style < ActiveRecord::Base
  include Permalinkable

  has_many   :beers
end
