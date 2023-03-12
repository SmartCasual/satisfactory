class Car
  attr_accessor :make, :model, :year, :color, :price, :wheels, :engine

  def initialize(make:, model:, wheels:, engine:)
    @make = make
    @model = model
    @wheels = wheels
    @engine = engine
  end
end

FactoryBot.define do
  factory :car do
    make { "Honda" }
    model { "Civic" }

    engine
    wheels { build_list(:wheel, 4, car: instance) }
  end
end

Satisfactory.factory_configurations[:car] = {
  associations: {
    plural: [:wheels],
    singular: [:engine],
  },
  model: Car,
  name: :car,
  parent: nil,
  traits: [],
}
