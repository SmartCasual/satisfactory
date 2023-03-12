class Car
  attr_accessor :make, :model, :year, :color, :price

  def initialize(make:, model:, year:, color:, price:)
    @make = make
    @model = model
    @year = year
    @color = color
    @price = price
  end
end

FactoryBot.define do
  factory :car do
    make { "Honda" }
    model { "Civic" }
    year { 2019 }
    color { "blue" }
    price { 20000 }
  end
end

Satisfactory.factory_configurations[:car] = {
  associations: Hash.new { |h, k| h[k] = [] },
  model: Car,
  name: :car,
  parent: nil,
  traits: [],
}
