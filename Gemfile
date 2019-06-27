source 'https://rubygems.org'

ruby '2.5.5'
#rvm-gemset=rails-4.2

gem 'rails', '4.2.11.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'puma', '~> 3.11'
gem 'pg', '0.21.0'
gem 'rake', '< 11.0'
gem 'bootstrap-sass', '~> 2.3.2'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem 'spring'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '~> 2.1'
  gem 'test-unit'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails', '~> 2.13'
end

group :production do
  gem 'rails_12factor', '0.0.2'
end
