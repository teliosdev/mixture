# encoding: utf-8

RSpec.describe Mixture::Validate::Presence do
  let(:options) { true }
  let(:record) { double("Record") }
  let(:attribute) { double("Attribute") }
  subject { described_class.new(options) }

  context "with an invalid value" do
    let(:value) { "" }

    it "raises an error" do
      expect { subject.validate(record, attribute, value) }
        .to raise_error(Mixture::ValidationError)
    end
  end

  context "with a valid value" do
    let(:value) { "hello" }

    it "does nothing" do
      expect { subject.validate(record, attribute, value) }
        .to_not raise_error
    end
  end
end
