# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paperclip/storage/version'

Gem::Specification.new do |gem|
  gem.name          = 'apress-paperclip-webdav'
  gem.version       = Paperclip::Storage::Webdav::VERSION
  gem.authors       = ['Nikita Vorobej', 'Merkushin']
  gem.email         = ['mail@gamersroom.ru']
  gem.description   = %q{Webdav storage for paperclip}
  gem.summary       = %q{Webdav storage for paperclip}
  gem.homepage      = 'https://github.com/abak-press/paperclip-webdav'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'paperclip', '~> 4.2'
  gem.add_runtime_dependency 'webdav-client', '~> 0.0.1'
  gem.add_runtime_dependency 'activesupport', '>= 3.0'

  gem.add_development_dependency 'bundler', '~> 1.6'
  gem.add_development_dependency 'apress-gems', '>= 0.0.4'
  gem.add_development_dependency 'rspec', '~> 3.1'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rake'
end
