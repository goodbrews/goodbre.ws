class Style < ActiveRecord::Base
  include Permalinkable
  belongs_to :category
  has_many   :beers
end
