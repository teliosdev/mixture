# encoding: utf-8

RSpec.describe Mixture::Coerce::Class do
  subject { Mixture::Coerce::Class.instance }
  let(:klass) { ::Struct.new(:name) }
  let(:value) { klass.new("Bob") }
  let(:type) { Mixture::Types::Class[klass] }

  describe "#to_class" do
    it "returns a proc" do
      expect(subject.to_class).to be_a Proc
    end

    it "returns a proc that returns the value" do
      expect(subject.to_class.call(value, type)).to be value
    end

    context "with a bad value" do
      let(:bad_class) { ::Struct.new(:age) }
      let(:bad_value) { bad_class.new(18) }

      it "returns a proc" do
        expect(subject.to_class).to be_a Proc
      end

      it "returns a proc that errors" do
        expect { subject.to_class.call(bad_value, type) }
          .to raise_error(Mixture::CoercionError)
      end
    end
  end

  describe "#to" do
    it "returns the proper coercion" do
      expect(subject.to(type)).to eq subject.to_class
    end
  end
end
