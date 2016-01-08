# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "spambox"
  gem.version       = "0.3.2"
  gem.date          = "2016-01-08"
  gem.authors       = ["Joshua Jansen"]
  gem.email         = ["joshuajansen88@gmail.com"]
  gem.description   = "Spambox uses Formbox.es API to check for spam."
  gem.summary       = "Spambox is a gem that checks your objects
    for unsafe keywords and returns a spam score."
  gem.homepage      = "https://github.com/joshuajansen/spambox"
  gem.files         = ["lib/spambox.rb"]
  gem.license       = "MIT"
  gem.add_runtime_dependency "sanitize", "~> 4.0"
end
