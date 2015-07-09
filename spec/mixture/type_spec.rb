# encoding: utf-8

RSpec.describe Mixture::Type do
  describe ".new" do
    it "is private" do
      expect { Mixture::Type.new }.to raise_error(NoMethodError)
    end
  end

  describe ".load" do
    subject { Mixture::Type[Array] }
    it "creates constant types" do
      expect(subject).to be Mixture::Type::Array
    end
  end

  describe ".from" do
    subject { Mixture::Type.from(Array) }

    it "returns the same instance" do
      expect(subject).to be Mixture::Type.from(Array)
    end
  end

  describe ".infer" do
    subject { Mixture::Type.infer(type) }
    context "with a class" do
      let(:type) { Integer }
      it { is_expected.to be Mixture::Type::Integer }
    end

    context "with an instance of Integer" do
      let(:type) { 1 }
      it { is_expected.to be Mixture::Type::Integer }
    end

    context "with a class" do
      class MyClass; end
      let(:type) { MyClass }
      it { is_expected.to be Mixture::Type[MyClass] }
    end

    context "with an object" do
      let(:type) { Object.new }
      it { is_expected.to be Mixture::Type::Object }
    end

    context "with a boolean" do
      let(:type) { false }
      it { is_expected.to be Mixture::Type::Boolean }
    end

    context "with a symbol alias" do
      let(:type) { :string }
      it { is_expected.to be Mixture::Type::String }
    end
  end

  describe "#to_s" do
    subject { Mixture::Type[Array] }
    it "uses the type's name" do
      expect(subject.to_s).to eq "Mixture::Type(Array)"
    end
  end

  describe "#method_name" do
    subject { Mixture::Type[Array] }
    it "uses the type's name" do
      expect(subject.method_name).to be :to_array
    end
  end
end
