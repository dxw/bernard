lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bernard/version'

Gem::Specification.new do |gem|
  gem.name          = 'bernard'
  gem.version       = Bernard::VERSION
  gem.date          = '2016-05-17'
  gem.summary       = 'Sends event data to visualisation services'
  gem.description   = 'Sends event data to visualisation services.'
  gem.authors       = ['Tom Hipkin', 'Robert Lee-Cann']
  gem.email         = ['tomh@dxw.com', 'leeky@dxw.com']
  gem.files         = ['lib/bernard.rb']
  gem.homepage      = 'https://github.com/dxw/bernard'
  gem.license       = 'MIT'

  gem.require_paths = ['lib']
  gem.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }

  gem.add_development_dependency 'rake', '11.1.2'
  gem.add_development_dependency 'rspec', '3.4.0'
  gem.add_development_dependency 'pry', '0.10.3'
  gem.add_development_dependency 'webmock', '1.24.2'
end
