source 'https://rubygems.org'

ruby '2.6.9'

gem 'rails', '~> 5.1.6'

gem 'puma', '~> 4.3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'draper'
# gem 'rmagick'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'bootstrap-sass'
gem 'devise'
gem 'devise-i18n'
# gem 'high_voltage'
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
gem 'axlsx', github: 'randym/axlsx'
gem 'axlsx_rails'
gem 'axlsx_styler'
gem 'paperclip', '~> 5.0'
gem 'acts-as-taggable-on'
gem 'browser'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-doc'
  gem 'rspec-rails'
  gem 'rubocop'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  # gem 'web-console', '>= 3.3.0'
  # gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # gem 'meta_request'
  # gem 'better_errors'
  gem 'capistrano', '~> 3.5'
  gem 'capistrano-bundler'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rails-console'
  # gem 'capistrano-rvm', '~> 0.1.1'
  gem 'capistrano-chruby'
  gem 'capistrano3-puma'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  gem 'spring-commands-rspec'
  gem 'mechanize'
  # gem 'binding_of_caller'
end

group :test do
  gem 'capybara', '~> 2.13'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', '~> 1.0.0', require: nil
end
