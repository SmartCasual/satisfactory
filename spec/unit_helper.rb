require "spec_helper"
require "satisfactory"

module Satisfactory
  # Registry of factory configurations for the unit suite, mirroring the shape
  # produced by Satisfactory::Loader but without requiring a Rails application
  # or ActiveRecord models.
  module UnitFactories
    def self.configurations
      @configurations ||= {}
    end
  end
end

Dir[File.join(__dir__, "test_factories", "**", "*_factory.rb")].each { |file| require file }

# A factory with a parent, used to exercise the single-table-inheritance style
# branches of Record#with. These branches are characterised through #build_plan,
# which never touches FactoryBot, so no FactoryBot factory is required.
Satisfactory::UnitFactories.configurations[:racing_wheel] = {
  associations: {
    plural: [],
    singular: [:car],
  },
  parent: :wheel,
}

RSpec.configure do |config|
  config.define_derived_metadata(file_path: %r{/spec/satisfactory/}) do |metadata|
    metadata[:unit] = true
  end

  # Each unit example gets a fresh copy of the injected configurations, isolated
  # from the lazily-derived configurations used by the Rails-backed acceptance
  # suite (which is restored by resetting the memoised value afterwards).
  config.before(:each, :unit) do
    Satisfactory.instance_variable_set(
      :@factory_configurations,
      Satisfactory::UnitFactories.configurations.transform_values(&:dup),
    )
  end

  config.after(:each, :unit) do
    Satisfactory.instance_variable_set(:@factory_configurations, nil)
  end
end
