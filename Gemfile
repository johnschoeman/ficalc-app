source "https://rubygems.org"

ruby                "2.7.1"

gem "rails",        "5.2.2"

gem "bootsnap"
gem "clearance"
gem "coffee-rails"
gem "jquery-rails"
gem "net-sftp"
gem "pg"
gem "puma"
gem "sass-rails"
gem "sidekiq"
gem "simple_form"
gem 'therubyracer', platforms: :ruby
gem "uglifier"
gem "libv8", github: "rubyjs/libv8", submodules: true
gem "nokogiri", "1.10.8"

group :development, :test do
  gem "dotenv-rails"
  gem "faker"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails"
end

group :test do
  gem "database_cleaner"
  gem "factory_bot"
  gem "guard",                    "2.13.0"
  gem "guard-minitest",           "2.4.4"
  gem "launchy"
  gem "phantomjs", require: "phantomjs/poltergeist"
  gem "poltergeist"
  gem "rspec"
  gem "rspec_junit_formatter"
  gem "shoulda-matchers"
end

group :development do
  gem "listen",                "3.0.8"
  gem "spring",                "1.7.2"
  gem "spring-watcher-listen", "2.0.0"
  gem "web-console",           "3.1.1"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
