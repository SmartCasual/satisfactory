require "spec_helper"

ENV["RAILS_ENV"] ||= "test"

Bundler.require(:default, :rails)

require_relative "dummy/config/environment"

require "rspec/rails"

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.filter_rails_from_backtrace!
end
