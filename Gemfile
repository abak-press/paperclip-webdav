source 'http://gems.railsc.ru'
source 'https://rubygems.org'

# Specify your gem's dependencies in paperclip-webdav.gemspec
gemspec
gem 'webdav-client', git: 'git@github.com:abak-press/webdav-client.git', branch: 'remove_curb'

if RUBY_VERSION < '2'
  gem 'activesupport', '< 5.0'
  gem 'mime-types', '< 3.0'
  gem 'pry-debugger'
else
  gem 'test-unit'
  gem 'pry-byebug'
end
