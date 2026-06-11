# Stands in for a model that belongs_to :car and is referenced as the plural
# :wheels association on Car.
class Wheel
  attr_accessor :car
end

FactoryBot.define do
  factory :wheel do
    trait :alloy do
      alloy { true }
    end
  end
end

Satisfactory::UnitFactories.configurations[:wheel] = {
  associations: {
    plural: [],
    singular: [:car],
  },
  model: Wheel,
  name: :wheel,
  parent: nil,
  traits: [:alloy],
}
