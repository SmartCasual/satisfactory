class Wheel
  attr_accessor :car
end

FactoryBot.define do
  factory :wheel do
    car
  end
end

Satisfactory.factory_configurations[:wheel] = {
  associations: {
    plural: [],
    singular: [:car],
  },
  model: Wheel,
  name: :wheel,
  parent: nil,
  traits: [],
}
