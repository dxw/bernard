require File.expand_path('../lib/bernard', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'bernard'
  gem.version     = '0.0.0'
  gem.date        = '2016-05-11'
  gem.summary     = 'Sends event data to visualisation services'
  gem.description = 'Sends event data to visualisation services.'
  gem.authors     = ['Tom Hipkin', '']
  gem.email       = ['tomh@dxw.com', '']
  gem.files       = ["lib/bernard.rb"]
  gem.homepage    = 'http://rubygems.org/gems/bernard'
  gem.license     = 'MIT'

  gem.version     = Bernard::VERSION
end
