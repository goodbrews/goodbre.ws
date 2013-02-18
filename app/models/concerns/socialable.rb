module Socialable
  extend ActiveSupport::Concern

  included do
    has_many :social_media_accounts, as: :socialable
  end

  def facebook_url
    return '' if self.is_a?(Beer)
    account = social_media_accounts.where(website: 'Facebook').first
    account ? "http://www.facebook.com/#{account.handle}" : ''
  end

  def twitter_url
    return '' if self.is_a?(Beer)
    account = social_media_accounts.where(website: 'Twitter').first
    account ? "http://twitter.com/#{account.handle}" : ''
  end

  def foursquare_url
    return '' if self.is_a?(Beer)
    account = social_media_accounts.where(website: 'Foursquare').first
    account ? "http://foursquare.com/v/#{account.handle}" : ''
  end

  def untappd_url
    account = social_media_accounts.where(website: 'Untappd').first
    account ? "http://untappd.com/#{self.class.downcase}/#{account.handle}" : ''
  end

  def ratebeer_url
    account = social_media_accounts.where(website: 'RateBeer').first
    return '' unless account

    case self
    when Beer
      "http://www.ratebeer.com/beer/#{self.permalink}/#{account.handle}"
    when Brewery
      "http://www.ratebeer.com/brewers/#{self.permalink}/#{account.handle}/"
    end
  end

  def beeradvocate_url
    account = social_media_accounts.where(website: 'BeerAdvocate').first
    return '' unless account

    case self
    when Beer
      '' # Looks like none of the beers have this yet. Hm.
    when Brewery
      "http://www.beeradvocate.com/beer/profile/#{account.handle}"
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
