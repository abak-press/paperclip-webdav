source 'https://gems.railsc.ru'
source 'https://rubygems.org'

# Specify your gem's dependencies in paperclip-webdav.gemspec
gemspec

gem 'webdav-client', git: 'git@github.com:abak-press/webdav-client.git', branch: 'remove_curb'

if RUBY_VERSION < '2'
  gem 'activesupport', '< 5.0'
  gem 'mime-types', '< 3.0'
  gem 'json', '< 2.0.0'
  gem 'rack', '< 2.0.0'
  gem 'public_suffix', '< 1.5.0'
  gem 'pg', '< 0.19.0'
  gem "pry-debugger", ">= 0.2.3"
else
  gem "test-unit"
  gem "pry-byebug"
end
