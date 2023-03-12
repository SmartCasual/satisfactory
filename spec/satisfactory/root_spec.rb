require "spec_helper"

require "satisfactory/root"

RSpec.describe Satisfactory::Root do
  subject(:root) { described_class.new }

  describe "#add(factory_name, **attributes)" do
    it "returns a record" do
      expect(root.add(:car)).to be_a(Satisfactory::Record)
    end

    it "raises an error if the factory is not defined" do
      expect { root.add(:banana) }.to raise_error(Satisfactory::Root::FactoryNotDefinedError)
    end

    it "adds the record to the root" do
      record = root.add(:car)
      expect(root.to_plan).to eq(car: [record.build_plan])
    end
  end
end
