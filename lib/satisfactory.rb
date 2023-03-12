require_relative "satisfactory/helpers"
require_relative "satisfactory/loader"
require_relative "satisfactory/root"

# Satisfactory is a factory library for Ruby,
# helping you to navigate your factory associations.
#
# Currently implemented atop FactoryBot, but
# could be extended to support other factory libraries.
#
# @since 0.2.0
module Satisfactory
  # @!attribute [r] factory_configurations
  class << self
    def root
      Root.new
    end

    # @api private
    # @return (see Loader.factory_configurations for Rails applications)
    def factory_configurations
      @factory_configurations ||= Loader.factory_configurations
    end
  end
end
