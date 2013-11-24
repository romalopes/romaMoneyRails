source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '4.0.1'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem "jquery-ui-rails", "~> 4.1.0"
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'bootstrap-sass', '~> 2.3.2.2'
gem 'figaro'
gem 'therubyracer', :platform=>:ruby
gem 'less'#, '2.2.2' 
gem 'less-rails'
gem "font-awesome-rails"
gem 'bcrypt-ruby', '3.1.2'
gem 'faker', '1.1.2'
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.9'
gem 'lazy_high_charts'
gem 'fuelux-rails' #, :git => 'git://github.com/stephenbaldwin/fuelux-rails.git'

#gem "twitter-bootstrap-rails"
group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  gem 'spork-rails', '4.0.0'
  gem 'guard-spork', '1.5.0'
  gem 'childprocess', '0.3.6'  
end
group :development, :test do
  gem 'sqlite3'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end
group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara'
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
end

group :production do
  gem 'rails_log_stdout',           github: 'heroku/rails_log_stdout'
  gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets'
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end

