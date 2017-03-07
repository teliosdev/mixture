# encoding: utf-8
# frozen_string_literal: true

RSpec.describe Mixture::Extensions::Hashable do
  model = Class.new do
    include Mixture::Extensions::Attributable
    include Mixture::Extensions::Hashable

    attribute :name
    attribute :age
  end

  subject { model.new }

  HASH_METHODS = %w(
    to_hash [] fetch []= store size length empty? each_value
    each_key each_pair each keys values has_key?
    has_value? key? value?
  ).map(&:intern)

  it "responds to hash methods" do
    HASH_METHODS.each do |method|
      expect(subject).to respond_to(method)
    end
  end

  context "#[]" do
    it "uses #attribute as an accessor" do
      expect(subject).to receive(:attribute).once.with(Symbol)
      subject[:name]
    end
  end

  context "#[]=" do
    it "uses #attribute as an accessor" do
      expect(subject).to receive(:attribute).once.with(Symbol, String)
      subject[:name] = "hello"
    end
  end

  context "#key?" do
    it "checks with the attribute list" do
      expect(model.attributes).to receive(:key?).once
        .with(Symbol).and_return(false)
      expect(subject.key?(:date)).to be_falsey
    end

    it "returns the proper value" do
      expect(subject.key?(:name)).to be_truthy
      expect(subject.key?(:age)).to be_truthy
      expect(subject.key?(:date)).to be_falsey
    end
  end

  context "#to_hash" do
    it "is an alias of #attributes" do
      expect(subject.to_hash).to be_a Hash
      expect(subject.to_hash).to eq subject.attributes
    end
  end

  context "#fetch" do
    let(:attributes) { { name: "hello" } }
    before(:each) { subject.attributes = attributes }
    context "with no default" do
      it "retrieves the right value" do
        expect(subject.fetch(:name)).to eq "hello"
      end

      it "raises on a bad key" do
        expect { subject.fetch(:date) }.to raise_error(KeyError)
      end
    end

    context "with an argument default" do
      it "retrieves the right value" do
        expect(subject.fetch(:name, "world")).to eq "hello"
      end

      it "returns the default on a bad key" do
        expect(subject.fetch(:date, "today")).to eq "today"
      end
    end

    context "with a block default" do
      it "retrieves the right value" do
        expect(subject.fetch(:name) { "world" }).to eq "hello"
      end

      it "returns the block default on a bad key" do
        expect(subject.fetch(:date) { 2 + 2 }).to eq 4
      end
    end
  end
end
