source 'https://rubygems.org'
# source 'http://gems.github.com'

gem 'activeresource'
gem 'rails', '~> 4.0'
gem 'rake'

gem 'compass'
gem 'curb'
gem 'delayed_job_active_record'
gem 'formtastic'
gem 'haml'
gem 'mysql2'
gem 'nokogiri'
gem 'sequencescape-client-api', github: 'jamesglover/sequencescape-client-api', tag: ' rc1.3.0', require: 'sequencescape'
gem 'uuidtools'
# gem "jquery-rails"

gem 'byebug'

group :development do
  gem 'rubocop'
  gem 'sinatra'
end

gem 'factory_girl_rails', groups: [:test, :cucumber]

group :test do
  gem 'mocha'
  gem 'shoulda'
end

group :cucumber do
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'minitest'
  gem 'poltergeist'
  gem 'timecop'
end

group :deployment do
  gem 'exception_notification'
  gem 'psd_logger', github: 'sanger/psd_logger'
  gem 'thin'
end
# Needed for the new asset pipeline

gem 'sass-rails'
gem 'therubyracer'
gem 'uglifier'
