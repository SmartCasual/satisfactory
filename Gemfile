source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gemspec

gem "byebug", "~> 11.1"
gem "rake", "~> 13.0"
gem "rspec", "~> 3.12"
gem "rubocop", "~> 1.47"
gem "yard", "~> 0.9"

group :rails do
  gem "database_cleaner", "~> 2.0"
  gem "pg", "~> 1.4"
  gem "puma", "~> 6.1"
  gem "rails", "~> 7.0"
  gem "rspec-rails", "~> 6.0"
end

group :test do
  gem "factory_bot", "~> 6.2"
end
