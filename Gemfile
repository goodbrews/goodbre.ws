source 'https://rubygems.org'

gem 'rails', github: 'rails/rails'
gem 'arel',  github: 'rails/arel'
gem 'activerecord-deprecated_finders', github: 'rails/activerecord-deprecated_finders'

gem 'puma'
gem 'pg'
gem 'haml', github: 'haml/haml', branch: '4-0-stable'
gem 'tire'

gem 'recommendable', :github => 'davidcelis/recommendable'

gem 'sidekiq', '~> 2.7.0'
gem 'sidekiq-unique-jobs', '~> 2.3.0'

# For the sidekiq web interface
gem 'sinatra', :require => nil
gem 'slim', '<= 1.3.0'

gem 'jquery-rails'
gem 'twitter-bootstrap-rails', '~> 2.2.0'
gem 'google-analytics-rails'
gem 'turbolinks'
gem 'gravatar_image_tag'
gem 'kaminari'

gem 'bcrypt-ruby', '~> 3.0.0'
gem 'newrelic_rpm'
gem 'newrelic-redis'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'font-awesome-rails'
  gem 'libv8', '~> 3.11.8'
  gem 'therubyracer'
  gem 'less-rails'
  gem 'sprockets-rails', github: 'rails/sprockets-rails'
  gem 'sass-rails',      github: 'rails/sass-rails'
  gem 'coffee-rails',    github: 'rails/coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', platforms: :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'minitest-rails'
  gem 'minitest-rails-capybara'
  gem 'miniskirt'
  gem 'capistrano'
  gem 'capistrano-maintenance'
  gem 'pry-rails'
  gem 'pry-coolline'
  gem 'quiet_assets', github: 'evrone/quiet_assets'
end
