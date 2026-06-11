require "unit_helper"

RSpec.describe Satisfactory::Root do
  subject(:root) { described_class.new }

  describe "#add" do
    it "returns a record" do
      expect(root.add(:car)).to be_a(Satisfactory::Record)
    end

    it "sets the root as the record's upstream" do
      expect(root.add(:car).upstream).to eq(root)
    end

    it "raises a FactoryNotDefinedError for an unknown factory" do
      expect { root.add(:spaceship) }.to raise_error(described_class::FactoryNotDefinedError)
    end

    it "adds the record to the root's plan" do
      record = root.add(:car)
      expect(root.to_plan).to eq(car: [record.build_plan])
    end

    it "groups multiple records of the same type" do
      root.add(:car)
      root.add(:car)
      expect(root.to_plan).to eq(car: [{}, {}])
    end
  end

  describe "#to_plan" do
    it "is empty when nothing has been added" do
      expect(root.to_plan).to eq({})
    end

    it "builds a plan per top-level type" do
      root.add(:car).with(:wheels)
      root.add(:engine).which_is(:turbo)

      expect(root.to_plan).to eq(
        car: [{ wheels: [{}] }],
        engine: [{ traits: %i[turbo] }],
      )
    end
  end

  describe "#upstream" do
    it "is nil" do
      expect(root.upstream).to be_nil
    end
  end
end
