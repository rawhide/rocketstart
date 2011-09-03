source 'http://rubygems.org'

gem 'rails', '=3.1.0'
gem 'warden', '=1.0.3'
gem 'rails_warden', '=0.5.2'
#gem 'rake', '=0.8.7'
gem 'rake', '=0.9.2'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

# Asset template engines
gem 'sass-rails', "~> 3.1.0.rc"
gem 'coffee-script'
gem 'uglifier'

gem 'jquery-rails'

gem 'nokogiri'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test, :development do
  gem "rspec-rails", '2.6.1.beta1'
  #gem 'machinist', '2.0.0.beta2', :require => 'machinist/active_record'
  gem 'machinist', '2.0.0.beta2'
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'email_spec'
  gem 'faker'
  gem 'rr'
  gem 'database_cleaner', '>=0.6.0.rc.2'
  gem 'turn', :require => false
end

group :production do
    gem 'therubyracer-heroku', '0.8.1.pre3'
    gem 'pg'
end
