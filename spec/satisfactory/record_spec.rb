require "unit_helper"

RSpec.describe Satisfactory::Record do
  subject(:record) { described_class.new(type: :car) }

  describe "#initialize" do
    it "raises for an unknown factory" do
      expect { described_class.new(type: :spaceship) }
        .to raise_error(ArgumentError, "Unknown factory spaceship")
    end

    it "resolves the type to the factory's parent when one is configured" do
      sti_record = described_class.new(type: :racing_wheel)

      expect(sti_record.type).to eq(:wheel)
      expect(sti_record.factory_name).to eq(:racing_wheel)
    end

    it "uses the type as the factory name by default" do
      expect(record.factory_name).to eq(:car)
    end
  end

  describe "#with" do
    context "with a singular association" do
      it "returns a record for the downstream type" do
        downstream = record.with(:engine)

        expect(downstream).to be_a(described_class)
        expect(downstream.type).to eq(:engine)
        expect(downstream.upstream).to eq(record)
      end

      it "raises when more than one is requested" do
        expect { record.with(2, :engine) }
          .to raise_error(ArgumentError, "Cannot create multiple of singular associations (e.g. belongs_to)")
      end

      context "when the association already exists" do
        before { record.with(:engine, cylinders: 8) }

        it "returns the existing record and ignores new attributes" do
          record.with(:engine, cylinders: 16).which_is(:turbo)
          expect(record.build_plan).to eq(engine: { traits: %i[turbo] })
        end

        it "overrides the existing record when forced" do
          record.with(:engine, force: true).which_is(:turbo)
          expect(record.build_plan).to eq(engine: { traits: %i[turbo] })
        end
      end
    end

    context "with a plural association" do
      it "returns a collection of the requested size" do
        downstream = record.with(2, :wheels)

        expect(downstream).to be_a(Satisfactory::Collection)
        expect(downstream.size).to eq(2)
        expect(downstream).to all(be_a(described_class))
      end

      it "defaults to a single record" do
        expect(record.with(:wheels).size).to eq(1)
      end

      it "appends to the collection when forced" do
        record.with(:wheels)
        record.with(:wheels, force: true)
        expect(record.build_plan).to eq(wheels: [{}, {}])
      end

      it "replaces the collection when not forced" do
        record.with(:wheels)
        record.with(2, :wheels)
        expect(record.build_plan).to eq(wheels: [{}, {}])
      end
    end

    context "with a child type belonging to a plural association (STI)" do
      it "adds the child under the plural association and returns the record" do
        downstream = record.with(:racing_wheel)

        expect(downstream).to be_a(described_class)
        expect(downstream.type).to eq(:wheel)
        expect(downstream.factory_name).to eq(:racing_wheel)
      end
    end

    # Record#with has a branch intended to handle the plural form of a child
    # type (e.g. :racing_wheels), but it looks the type up with a String key
    # (downstream_type.to_s.singularize) against the Symbol-keyed configuration
    # hash, so the branch is currently unreachable and the call falls through to
    # the "Unknown association" error. These specs pin that current behaviour.
    context "with the plural of a child type (STI)" do
      it "raises, because the pluralised child lookup never matches" do
        expect { record.with(2, :racing_wheels) }
          .to raise_error(ArgumentError, "Unknown association car->racing_wheels")
      end
    end

    context "with the plural of a parentless singular type" do
      it "raises, because the pluralised lookup never matches" do
        expect { record.with(:engines) }
          .to raise_error(ArgumentError, "Unknown association car->engines")
      end
    end

    context "with an unknown association" do
      it "raises" do
        expect { record.with(:spaceship) }
          .to raise_error(ArgumentError, "Unknown association car->spaceship")
      end
    end
  end

  describe "#with_new" do
    it "always creates a new record rather than reusing the existing one" do
      record.with(:engine)
      record.with_new(:engine).which_is(:turbo)
      expect(record.build_plan).to eq(engine: { traits: %i[turbo] })
    end
  end

  describe "#and" do
    it "adds a sibling to the upstream record" do
      engine = record.with(:engine)
      engine.and(:wheels)

      expect(record.build_plan).to eq(wheels: [{}])
    end
  end

  describe "#which_is" do
    it "applies traits and returns itself" do
      expect(record.which_is(:sporty, :fast)).to eq(record)
      expect(record.traits).to eq(%i[sporty fast])
    end
  end

  describe "#and_same / #return_to" do
    it "returns a finder for the nearest ancestor of the given type" do
      engine = record.with(:engine)

      expect(engine.and_same(:car)).to be_a(Satisfactory::UpstreamRecordFinder)
      expect(engine.return_to(:car)).to be_a(Satisfactory::UpstreamRecordFinder)
    end

    it "allows building to continue from the ancestor" do
      engine = record.with(:engine)
      engine.and_same(:car).with(:wheels)

      expect(record.build_plan).to eq(wheels: [{}])
    end
  end

  describe "#build_plan" do
    it "is empty for a record with no traits or associations" do
      expect(record.build_plan).to eq({})
    end

    it "includes traits" do
      record.which_is(:sporty)
      expect(record.build_plan).to eq(traits: %i[sporty])
    end

    it "omits provided attributes" do
      car = described_class.new(type: :car, attributes: { make: "Tesla" })
      expect(car.build_plan).to eq({})
    end

    it "drops a singular association that carries no traits" do
      record.with(:engine, cylinders: 8)
      expect(record.build_plan).to eq({})
    end

    it "keeps a singular association that carries traits" do
      record.with(:engine).which_is(:turbo)
      expect(record.build_plan).to eq(engine: { traits: %i[turbo] })
    end

    it "keeps a plural association as an array even without traits" do
      record.with(2, :wheels)
      expect(record.build_plan).to eq(wheels: [{}, {}])
    end

    it "includes traits on plural association members" do
      record.with(:wheels).which_are(:alloy)
      expect(record.build_plan).to eq(wheels: [{ traits: %i[alloy] }])
    end
  end

  describe "#build" do
    it "builds the record via FactoryBot with its factory defaults" do
      built = record.build

      expect(built).to be_a(Car)
      expect(built.make).to eq("Honda")
      expect(built.wheels.size).to eq(4)
    end

    it "applies provided associations and their attributes" do
      record.with(:engine, cylinders: 8)
      built = record.build

      expect(built.engine).to be_a(Engine)
      expect(built.engine.cylinders).to eq(8)
    end
  end

  describe "#to_plan" do
    it "delegates to the root of the tree" do
      root = Satisfactory::Root.new
      car = root.add(:car)
      car.with(:wheels)

      expect(car.to_plan).to eq(car: [{ wheels: [{}] }])
    end
  end
end
