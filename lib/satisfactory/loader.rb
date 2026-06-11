require "factory_bot_rails"

module Satisfactory
  # Loads factory configurations from FactoryBot.
  #
  # @api private
  class Loader
    class << self
      # Skips factories that don't have a model that inherits from ApplicationRecord.
      #
      # @return [{Symbol => Hash}] a hash of factory configurations by factory name
      def factory_configurations
        FactoryBot.factories.each.with_object({}) do |factory, configurations|
          next unless (model = factory.build_class)
          next unless model < ApplicationRecord

          configurations[factory.name] = configuration_for(factory, model)
        end
      end

    private

      def configuration_for(factory, model)
        parent_factory = factory.send(:parent)

        {
          associations: associations_for(model).transform_values { |a| a.map(&:name) },
          model:,
          name: factory.name,
          parent: (parent_factory.name unless parent_factory.is_a?(FactoryBot::NullFactory)),
          traits: factory.defined_traits.map(&:name),
        }
      end

      def associations_for(model)
        all = model.reflect_on_all_associations.reject(&:polymorphic?)
        plural = model.reflect_on_all_associations(:has_many).reject(&:polymorphic?)

        {
          plural:,
          singular: all - plural,
        }
      end
    end
  end
end
