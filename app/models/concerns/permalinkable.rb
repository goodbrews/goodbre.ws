module Permalinkable
  extend ActiveSupport::Concern

  included do
    before_create :set_permalink
    validates :permalink, uniqueness: { case_sensitive: false }

    scope :from_param, -> { where(permalink: param).first }
  end

  def to_param
    self.permalink
  end

  private
    def set_permalink
      self.permalink = self.name
    end
end
