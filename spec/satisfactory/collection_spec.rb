require "unit_helper"

RSpec.describe Satisfactory::Collection do
  subject(:collection) { root.add(:car).with(2, :wheels) }

  let(:root) { Satisfactory::Root.new }

  it "is an Array of records" do
    expect(collection).to be_a(Array)
    expect(collection).to all(be_a(Satisfactory::Record))
  end

  describe "#with / #each_with" do
    it "calls #with on each entry and returns a new collection" do
      result = collection.with(:car)

      expect(result).to be_a(described_class)
      expect(result.size).to eq(2)
    end

    it "aliases #each_with to #with" do
      expect(collection.method(:each_with)).to eq(collection.method(:with))
    end
  end

  describe "#which_are / #which_is" do
    it "applies traits to every entry and returns a new collection" do
      result = collection.which_are(:alloy)

      expect(result).to be_a(described_class)
      expect(result.map(&:traits)).to eq([%i[alloy], %i[alloy]])
    end

    it "aliases #which_is to #which_are" do
      expect(collection.method(:which_is)).to eq(collection.method(:which_are))
    end
  end

  describe "#build_plan" do
    it "flat maps the build plans of its entries" do
      collection.which_are(:alloy)

      expect(collection.build_plan).to eq([{ traits: %i[alloy] }, { traits: %i[alloy] }])
    end
  end

  describe "delegation to the upstream record" do
    it "delegates #to_plan" do
      collection.which_are(:alloy)

      expect(collection.to_plan).to eq(car: [{ wheels: [{ traits: %i[alloy] }, { traits: %i[alloy] }] }])
    end

    it "delegates #and to the upstream record" do
      expect(collection.upstream).to receive(:and).with(:engine)
      collection.and(:engine)
    end
  end

  describe "#and_same / #return_to" do
    it "returns a finder for the nearest ancestor of the given type" do
      expect(collection.and_same(:car)).to be_a(Satisfactory::UpstreamRecordFinder)
      expect(collection.return_to(:car)).to be_a(Satisfactory::UpstreamRecordFinder)
    end
  end
end
