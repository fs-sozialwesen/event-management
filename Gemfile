source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

gem 'rails', '~> 6.0.6'

gem 'puma', '~> 6.0'
gem 'sass-rails', '~> 6.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 5.0'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'draper'
# gem 'rmagick'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'tzinfo-data', platforms: %i(mingw mswin x64_mingw jruby)
gem 'bootstrap-sass'
gem 'devise'
gem 'devise-i18n'
gem 'pg'
gem 'pg_search'
gem 'rails-settings-cached'
gem 'pundit'
gem 'simple_form'
gem 'slim-rails'
gem 'font-awesome-rails'
gem 'bootstrap-wysihtml5-rails'
gem 'select2-rails'
gem 'bootstrap-datepicker-rails'
gem 'virtus'
gem 'rollbar'
gem 'paper_trail'
gem 'kaminari'
# gem 'reverse_markdown'
gem 'prawn'
# See https://github.com/prawnpdf/prawn-table/pull/50
gem 'prawn-table', git: 'https://github.com/J-F-Liu/prawn-table'

gem 'wkhtmltopdf-binary', '0.12.3.1' # https://github.com/mileszs/wicked_pdf/issues/721#issuecomment-429560752
gem 'wicked_pdf'

# gem 'rubyzip', '~> 1.1.0'
# gem 'axlsx', '2.1.0.pre'
# no new gem out yet using the new rubyzip version
gem 'caxlsx'
gem 'caxlsx_rails'
gem 'axlsx_styler'
gem 'paperclip', '~> 6.1'
gem 'browser'
gem 'brakeman'
gem 'bundler-audit'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-git', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  # gem 'web-console', '>= 3.3.0'
  gem 'listen'
  # gem 'meta_request'
  # gem 'better_errors'
  gem 'rails_layout'
  gem 'mechanize'
  # gem 'binding_of_caller'
end

group :test do
  gem 'capybara', '~> 3.36'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
end
