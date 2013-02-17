class SocialMediaAccount < ActiveRecord::Base
  belongs_to :socialable, polymorphic: true
end
