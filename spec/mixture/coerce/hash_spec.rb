# encoding: utf-8
# frozen_string_literal: true

RSpec.describe Mixture::Coerce::Hash do
  subject { Mixture::Coerce::Hash.instance }
  let(:hash) { { "1" => "2", "3" => "4" } }
  let(:type) { Mixture::Types::Hash[::Integer, ::Integer] }

  describe "#to_hash" do
    subject { Mixture::Coerce::Hash.instance.to_hash }
    it { is_expected.to be_a Proc }

    it "coerces a hash" do
      expect(subject[hash, type]).to eq 1 => 2, 3 => 4
    end
  end
end
