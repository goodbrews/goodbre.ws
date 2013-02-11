require 'miniskirt'

Factory.define :user do |f|
  f.email    'user%d@goodbre.ws'
  f.username 'user%d'
  f.password f.password_confirmation 'supersecret'
  f.first_name 'Joe'
  f.last_name 'Schmoe'
  f.city 'Portland'
  f.region 'OR'
  f.country 'USA'
end
