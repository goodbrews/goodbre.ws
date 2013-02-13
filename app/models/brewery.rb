class Brewery < ActiveRecord::Base
  before_create :set_permalink

  def to_param
    permalink
  end

  def self.from_param(param)
    where(:permalink => param).first
  end

  def self.paginate(options = {})
    page(options[:page]).per(options[:per_page])
  end

  private

  def set_permalink
    self.permalink = self.name.parameterize
  end
end
