# encoding: utf-8
# frozen_string_literal: true

RSpec.describe Mixture::Validate::Length do
  let(:options) { { in: 5..20 } }
  let(:record) { double("Record") }
  let(:attribute) { double("Attribute") }

  subject { described_class.new(options) }

  context "with an invalid value" do
    let(:value) { "he" }

    it "raises an error" do
      expect { subject.validate(record, attribute, value) }
        .to raise_error(Mixture::ValidationError)
    end
  end

  context "with a valid value" do
    let(:value) { "world" }

    it "does nothing" do
      expect { subject.validate(record, attribute, value) }
        .to_not raise_error
    end
  end

  context "with a numeric option" do
    let(:options) { 5 }
    it "creates a range" do
      expect(subject.acceptable).to eq(5..5)
    end
  end

  context "with a range option" do
    let(:options) { 20..100 }
    it "uses the range" do
      expect(subject.acceptable).to eq(20..100)
    end
  end

  context "with an invalid option" do
    let(:options) { nil }

    it "raises an error" do
      expect { subject.acceptable }
        .to raise_error(Mixture::ValidationError)
    end
  end

  context "with a non-length value" do
    let(:value) { 1.0 }

    it "raises an error" do
      expect { subject.validate(record, attribute, value) }
        .to raise_error(Mixture::ValidationError)
    end
  end

  context "with an array option" do
    let(:options) { [30, 90] }
    it "creates a range" do
      expect(subject.acceptable).to eq(30..90)
    end
  end

  context "with a hash option" do
    context "with only a :minimum key" do
      let(:options) { { minimum: 5 } }
      it "creates a range" do
        expect(subject.acceptable).to eq(5..Float::INFINITY)
      end
    end

    context "with only a :maximum key" do
      let(:options) { { maximum: 20 } }
      it "creates a range" do
        expect(subject.acceptable).to eq(0..20)
      end
    end

    context "with both a :minimum and :maximum key" do
      let(:options) { { minimum: 5, maximum: 20 } }
      it "creates a range" do
        expect(subject.acceptable).to eq(5..20)
      end
    end

    context "with an :is key" do
      let(:options) { { is: 3 } }
      it "creates a range" do
        expect(subject.acceptable).to eq(3..3)
      end
    end

    context "with an :in key" do
      let(:options) { { in: 5..20 } }
      it "creates a range" do
        expect(subject.acceptable).to eq(5..20)
      end
    end

    context "with no usable keys" do
      let(:options) { { hello: "world" } }
      it "raises an error" do
        expect { subject.acceptable }
          .to raise_error(Mixture::ValidationError)
      end
    end
  end
end
