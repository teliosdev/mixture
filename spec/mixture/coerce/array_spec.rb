# encoding: utf-8

RSpec.describe Mixture::Coerce::Array do
  subject { Mixture::Coerce::Array.instance }
  let(:array) { [1, 2, 3] }

  it { is_expected.to respond_to(:to) }
  it { is_expected.to respond_to(:to_array) }

  describe "#to_array" do
    it "returns a block" do
      expect(subject.to_array).to be_a Proc
    end

    it "returns a block that returns an array" do
      expect(subject.to_array[array]).to be array
    end
  end

  describe "#to" do
    it "loads the proper coercion" do
      expect(subject.to(Mixture::Type::Array)).to eq subject.to_array
    end
  end

  describe ".to" do
    subject { described_class }
    it "loads the proper coercion" do
      expect(subject.to(Mixture::Type::Array)).to eq subject.instance.to_array
    end
  end
end
