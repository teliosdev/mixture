# encoding: utf-8
# frozen_string_literal: true

RSpec.describe Mixture::Coerce::Set do
  subject { Mixture::Coerce::Set.instance }
  let(:value) { Set["1", "2", "3"] }
  let(:type) { Mixture::Types::Set[Mixture::Types::Integer] }

  describe "#to_set" do
    subject { Mixture::Coerce::Set.instance.to_set }
    it { is_expected.to be_a Proc }

    it "coerces a set" do
      expect(subject[value, type]).to eq Set[1, 2, 3]
    end
  end

  describe "#to_array" do
    let(:type) { Mixture::Types::Array[Mixture::Types::Integer] }
    subject { Mixture::Coerce::Set.instance.to_array }
    it { is_expected.to be_a Proc }

    it "coerces a set" do
      expect(subject[value, type]).to eq [1, 2, 3]
    end
  end
end
