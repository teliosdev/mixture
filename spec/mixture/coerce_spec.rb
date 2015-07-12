# encoding: utf-8

RSpec.describe Mixture::Coerce do
  subject { Mixture::Coerce }

  describe ".coercers" do
    subject { Mixture::Coerce.coercers }
    it { is_expected.to be_a Hash }
    it "maps types to coercers" do
      expect(subject.keys.all? { |k| k <= Mixture::Types::Type })
        .to be_truthy
      expect(subject.values.all? { |k| k < Mixture::Coerce::Base })
        .to be_truthy
      expect(subject[Mixture::Types::Array]).to be Mixture::Coerce::Array
    end
  end

  describe ".perform" do
    subject { Mixture::Coerce.perform(type, value) }
    let(:type) { Mixture::Types::Array[Mixture::Types::Integer] }
    let(:value) { %w(1 2 3) }

    it { is_expected.to be_a Array }
    it "returns the coerced value" do
      expect(subject).to eq [1, 2, 3]
    end

    context "with a bad value" do
      let(:value) { Object.new }

      it "raises an error" do
        expect { subject }.to raise_error(Mixture::CoercionError)
      end
    end
  end

  describe ".coerce" do
    subject { Mixture::Coerce.coerce(from, to) }
    let(:from) { Mixture::Types::Array }
    let(:to) { Mixture::Types::Hash }
    let(:array) { [%w(foo bar), %w(hello world)] }

    it { is_expected.to be_a Proc }
    it "is defined by coerce" do
      expect(subject).to be Mixture::Coerce::Array.instance.to_hash
    end

    it "returns a callable block" do
      expect(subject[array, to]).to be_a Hash
    end

    context "with an undefined coercion" do
      let(:to) { Mixture::Types::Float }

      it "fails" do
        expect { subject }.to raise_error(Mixture::CoercionError)
      end
    end
  end
end
