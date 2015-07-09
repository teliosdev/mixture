# encoding: utf-8

RSpec.describe Mixture::Coerce do
  subject { Mixture::Coerce }

  describe ".coercers" do
    subject { Mixture::Coerce.coercers }
    it { is_expected.to be_a Hash }
    it "maps types to coercers" do
      expect(subject.keys.all? { |k| k.is_a?(Mixture::Type) })
        .to be_truthy
      expect(subject.values.all? { |k| k < Mixture::Coerce::Base })
        .to be_truthy
      expect(subject[Mixture::Type::Array]).to be Mixture::Coerce::Array
    end
  end

  describe ".coerce" do
    subject { Mixture::Coerce.coerce(from: from, to: to) }
    let(:from) { Mixture::Type::Array }
    let(:to) { Mixture::Type::Hash }
    let(:array) { [%w(foo bar), %w(hello world)] }

    it { is_expected.to be_a Proc }
    it "is defined by coerce" do
      expect(subject).to be Mixture::Coerce::Array.instance.to_hash
    end

    it "returns a callable block" do
      expect(subject[array]).to be_a Hash
    end

    context "with an undefined coercion" do
      let(:to) { Mixture::Type::Float }

      it "fails" do
        expect { subject }.to raise_error(Mixture::CoercionError)
      end
    end
  end
end
