source 'https://rubygems.org'
#source 'http://gems.github.com'

gem 'rails', '3.0.19'
gem 'rake', '0.8.7'

gem 'nokogiri'
gem "formtastic"
gem "mysql2"
gem "activerecord-mysql2-adapter"
gem "uuidtools"
gem "compass"
gem 'curb'
gem 'haml'
gem 'sequencescape-client-api', :github => 'sanger/sequencescape-client-api', :tag => 'release-0.2.6', :require => 'sequencescape'
gem 'delayed_job'
gem "jquery-rails"

gem "debugger", :require => "debugger", :groups => [:development, :test, :cucumber]

group :development do
  gem "sinatra"
end

gem "factory_girl_rails", :groups => [:test,:cucumber]

group :test do
  gem "mocha"
  gem "shoulda"
end

group :cucumber do
  gem "capybara"
  gem "cucumber-rails", :require => false
  gem "database_cleaner"
  gem "launchy"
  gem "timecop"
  gem "poltergeist"
end

group :deployment do
  gem 'thin'
  gem "psd_logger", :github => "sanger/psd_logger"
  gem 'exception_notification'
end
