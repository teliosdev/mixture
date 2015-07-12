# encoding: utf-8

RSpec.describe Mixture::Types do
  describe ".infer" do
    subject { Mixture::Types.infer(type) }
    context "with a class" do
      let(:type) { Integer }
      it { is_expected.to be Mixture::Types::Integer }
    end

    context "with an instance of Integer" do
      let(:type) { 1 }
      it { is_expected.to be Mixture::Types::Integer }
    end

    context "with a class" do
      class MyClass; end
      let(:type) { MyClass }
      it { is_expected.to be Mixture::Types::Class[MyClass] }
    end

    context "with an object" do
      let(:type) { Object.new }
      it { is_expected.to be Mixture::Types::Object }
    end

    context "with a boolean" do
      let(:type) { false }
      it { is_expected.to be Mixture::Types::Boolean }
    end

    context "with a symbol alias" do
      let(:type) { :string }
      it { is_expected.to be Mixture::Types::String }
    end

    context "with an array" do
      let(:type) { Array[String] }
      it { is_expected.to be Mixture::Types::Array[Mixture::Types::String] }
      it { is_expected.to be Mixture::Types::Array[String] }
    end
  end
end
