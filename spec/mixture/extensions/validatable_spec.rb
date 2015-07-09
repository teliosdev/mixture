# encoding: utf-8

RSpec.describe Mixture::Extensions::Validatable do
  model = Class.new do
    include Mixture::Extensions::Attributable
    include Mixture::Extensions::Validatable

    attribute :name
    validate :name, format: /^.{3,20}$/
  end

  subject { model.new }
  let(:attr) { model.attributes[:name] }
  let(:attributes) { { name: "hello" } }

  describe ".validate" do
    it "sets the :validate option on the attribute" do
      expect(attr.options[:validate]).to be_a Hash
    end
  end

  describe "#valid?" do
    before(:each) { subject.attributes = attributes }
    context "with a valid value" do
      let(:attributes) { { name: "hello" } }
      it "returns a true value" do
        expect(subject.valid?).to be_truthy
        expect(subject.invalid?).to be_falsey
      end

      it "doesn't fill #errors" do
        expect(subject.errors).to be_empty
      end
    end

    context "with an invalid value" do
      let(:attributes) { { name: "a" } }
      it "returns a false value" do
        expect(subject.valid?).to be_falsey
        expect(subject.invalid?).to be_truthy
      end

      it "fills #errors" do
        expect(subject.valid?).to be_falsey
        expect(subject.errors).to_not be_empty
        expect(subject.errors[attr]).to_not be_empty
        expect(subject.errors[attr].size).to be 1
        expect(subject.errors[attr][0]).to be_a Mixture::ValidationError
      end
    end
  end
end
