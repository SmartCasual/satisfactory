require "unit_helper"

RSpec.describe Satisfactory::UpstreamRecordFinder do
  subject(:finder) { described_class.new(upstream:) }

  let(:root) { Satisfactory::Root.new }
  let(:car) { root.add(:car) }

  describe "#find" do
    context "when the upstream already matches the type" do
      let(:upstream) { car }

      it "returns itself" do
        expect(finder.find(:car)).to eq(finder)
      end
    end

    context "when an ancestor matches the type" do
      let(:upstream) { car.with(:engine) }

      it "walks up the tree and points at the matching ancestor" do
        expect(finder.find(:car)).to eq(finder)
        expect(finder.upstream).to eq(car)
      end
    end

    context "when no ancestor matches the type" do
      # An orphan record whose own upstream is nil, so the walk runs off the top.
      let(:upstream) { Satisfactory::Record.new(type: :car) }

      it "raises a MissingUpstreamRecordError" do
        expect { finder.find(:engine) }.to raise_error(described_class::MissingUpstreamRecordError)
      end
    end
  end

  describe "#with" do
    let(:upstream) { car }

    it "forces a new association on the upstream record" do
      finder.with(:wheels)
      expect(car.build_plan).to eq(wheels: [{}])
    end
  end

  describe "delegation to the upstream record" do
    let(:upstream) { car }

    it "delegates #to_plan" do
      car.with(:wheels)
      expect(finder.to_plan).to eq(car.to_plan)
    end

    it "delegates #with_new" do
      finder.with_new(:engine).which_is(:turbo)
      expect(car.build_plan).to eq(engine: { traits: %i[turbo] })
    end
  end
end
