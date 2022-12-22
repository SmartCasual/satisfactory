require "spec_helper"

ENV["RAILS_ENV"] ||= "test"

Bundler.require(:default, :rails)

require_relative "dummy/config/environment"

require "rspec/rails"

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.filter_rails_from_backtrace!
end
