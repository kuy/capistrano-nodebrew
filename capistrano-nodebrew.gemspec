# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "capistrano-nodebrew"
  gem.version       = "0.0.3"
  gem.authors       = ["Yuki Kodama"]
  gem.email         = ["endflow.net@gmail.com"]
  gem.description   = %q{nodebrew integration for Capistrano}
  gem.summary       = %q{nodebrew integration for Capistrano}
  gem.homepage      = "https://github.com/kuy/capistrano-nodebrew"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'capistrano', '~> 3.1'
  gem.add_dependency 'sshkit', '~> 1.3'
end
