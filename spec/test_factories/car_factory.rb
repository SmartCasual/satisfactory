# Plain Ruby stand-ins for the unit suite so that the DSL can be exercised
# without booting Rails or defining ActiveRecord models. Attributes are set via
# accessors so FactoryBot can build instances with its default strategy.
class Car
  attr_accessor :make, :model, :year, :colour, :price, :wheels, :engine
end

FactoryBot.define do
  factory :car do
    make { "Honda" }
    model { "Civic" }

    engine
    wheels { build_list(:wheel, 4, car: instance) }
  end
end

# The configuration mirrors the shape produced by Satisfactory::Loader for a
# model with one singular (belongs_to/has_one style) and one plural (has_many)
# association.
Satisfactory::UnitFactories.configurations[:car] = {
  associations: {
    plural: [:wheels],
    singular: [:engine],
  },
  model: Car,
  name: :car,
  parent: nil,
  traits: [],
}
