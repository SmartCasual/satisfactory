# Stands in for a model that belongs_to :car. The belongs_to association is
# intentionally omitted from the FactoryBot factory to keep #build acyclic; the
# association still appears in the configuration below so the DSL's singular
# association handling can be characterised.
class Engine
  attr_accessor :car, :cylinders
end

FactoryBot.define do
  factory :engine do
    cylinders { 4 }

    trait :turbo do
      cylinders { 8 }
    end
  end
end

Satisfactory::UnitFactories.configurations[:engine] = {
  associations: {
    plural: [],
    singular: [:car],
  },
  model: Engine,
  name: :engine,
  parent: nil,
  traits: [:turbo],
}
