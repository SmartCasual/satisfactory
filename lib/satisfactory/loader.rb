require "factory_bot_rails"

module Satisfactory
  class Loader
    class << self
      def factory_configurations
        each_factory.with_object({}) do |(factory, model), hash|
          associations = associations_for(model)
          parent_factory = factory.send(:parent)

          hash[factory.name] = {
            associations: associations.transform_values(&:name),
            model:,
            name: factory.name,
            parent: (parent_factory.name unless parent_factory.is_a?(FactoryBot::NullFactory)),
            traits: factory.defined_traits.map(&:name),
          }
        end
      end

    private

      def each_factory
        FactoryBot.factories.each do |factory|
          next unless (model = factory.build_class)
          next unless model < ApplicationRecord

          yield [factory, model]
        end
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
