# -*- encoding: utf-8 -*-
require File.expand_path('../lib/oauthorizer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Fletcher Fowler"]
  gem.email         = ["fletch@zambonidev.com"]
  gem.description   = %q{A gem to make oauth testing easier}
  gem.summary       = %q{Uses rack middleware and capbara to get oauth and refresh tokens from providers}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "oauthorizer"
  gem.require_paths = ["lib"]
  gem.version       = Oauthorizer::VERSION
  gem.add_runtime_dependency 'capybara'
end
