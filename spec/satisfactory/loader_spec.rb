require "rails_helper"

RSpec.describe Satisfactory::Loader do
  subject(:configurations) { described_class.factory_configurations }

  it "returns a configuration for each ActiveRecord-backed factory" do
    expect(configurations.keys).to contain_exactly(
      :candidate,
      :application_form,
      :application_choice,
      :course_option,
    )
  end

  describe "an individual configuration" do
    subject(:configuration) { configurations[:application_form] }

    it "records the factory name and model" do
      expect(configuration[:name]).to eq(:application_form)
      expect(configuration[:model]).to eq(ApplicationForm)
    end

    it "splits associations into plural and singular" do
      expect(configuration[:associations]).to eq(
        plural: [:application_choices],
        singular: [:candidate],
      )
    end

    it "records the defined traits (by their String names)" do
      expect(configuration[:traits]).to eq(["submitted"])
    end

    it "has no parent factory" do
      expect(configuration[:parent]).to be_nil
    end
  end

  it "excludes polymorphic associations and non-ActiveRecord factories" do
    expect(configurations).not_to have_key(:car)
    expect(configurations[:candidate][:associations]).to eq(
      plural: [:application_forms],
      singular: [],
    )
  end
end
