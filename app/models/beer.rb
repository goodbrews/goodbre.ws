class Beer < ActiveRecord::Base
  has_many :breweries

  before_create :set_permalink

  def self.paginate(options = {})
    page(options[:page]).per(options[:per_page])
  end

  private

  def set_permalink
    self.permalink = self.name.parameterize
  end
end
