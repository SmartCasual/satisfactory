require "spec_helper"

require "satisfactory/record"

RSpec.describe Satisfactory::Record do
  subject(:record) { described_class.new(type: :car) }

  describe "#with(count = nil, downstream_type, force: false, **attributes)" do
    let(:downstream_record) { record.with(downstream_type, **attributes) }
    let(:attributes) { {} }

    context "with a singular association" do
      let(:downstream_type) { :engine }

      it "returns a record for the downstream type" do
        expect(downstream_record).to be_a(described_class)
        expect(downstream_record.type).to eq(:engine)
      end

      context "with attributes" do
        let(:attributes) { { cylinders: 8 } }

        it "adds the associated record to this record's build plan" do
          downstream_record
          expect(record.build_plan).to eq(engine: { cylinders: 8 })
        end
      end

      context "without attributes" do
        it "adds the associated record to this record's build plan" do
          downstream_record
          expect(record.build_plan).to eq(engine: {})
        end
      end

      context "when more than one record is requested" do
        let(:downstream_record) { record.with(2, downstream_type) }

        it "raises an error" do
          expect { downstream_record }.to raise_error(ArgumentError)
        end
      end

      context "when the downstream type is already associated" do
        before { record.with(downstream_type, cylinders: 8) }

        it "does nothing" do
          record.with(downstream_type, cylinders: 16)
          expect(record.build_plan).to eq(engine: { cylinders: 8 })
        end

        context "when force is true" do
          it "overrides the existing association" do
            record.with(downstream_type, cylinders: 16, force: true)
            expect(record.build_plan).to eq(engine: { cylinders: 16 })
          end
        end
      end
    end
  end
end
