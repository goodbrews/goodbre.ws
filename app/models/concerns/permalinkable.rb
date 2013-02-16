module Permalinkable
  extend ActiveSupport::Concern

  included do
    before_create :set_permalink
    validates_uniqueness_of :permalink, case_sensitive: false
  end

  module ClassMethods
    def from_param(param)
      where(permalink: param).first
    end
  end

  def to_param
    self.permalink
  end

  private
    def set_permalink
      self.permalink = self.name
    end
end
