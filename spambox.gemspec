# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = 'spambox'
  gem.version       = '0.2'
  gem.date          = '2015-12-04'
  gem.authors       = ["Joshua Jansen"]
  gem.email         = ["joshuajansen88@gmail.com"]
  gem.description   = %q{Spambox uses Formbox.es API to check for spam.}
  gem.summary       = %q{Spambox is a gem that checks your objects for unsafe keywords and returns a spam score.}
  gem.homepage      = "https://github.com/joshuajansen/spambox"
  gem.files         = ["lib/spambox.rb"]
  gem.license       = 'MIT'
  gem.add_runtime_dependency "sanitize", "~> 4.0"
end
