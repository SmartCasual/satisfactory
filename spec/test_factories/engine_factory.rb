class Engine
  attr_accessor :car, :cylinders
end

FactoryBot.define do
  factory :engine do
    car

    cylinders { 4 }
  end
end

Satisfactory.factory_configurations[:engine] = {
  associations: {
    plural: [],
    singular: [:car],
  },
  model: Engine,
  name: :engine,
  parent: nil,
  traits: [],
}
