# encoding: utf-8

RSpec.describe Mixture::Extensions::Coercable do
  # A basic test model.
  model = Class.new do
    include Mixture::Extensions::Attributable
    include Mixture::Extensions::Coercable

    attribute :name, type: String
    attribute :date, type: Date
  end
  subject { model.new }
  let(:attr) { model.attributes[:name] }
  let(:attributes) { { name: 1, date: "2001-02-03" } }

  describe "#coerce_attribute" do
    before(:each) { subject.attributes = attributes }
    it "coerces a given attribute" do
      expect(subject.name).to be_a String
      expect(subject.name).to eq "1"
      expect(subject.date).to be_a Date
      expect(subject.date).to eq Date.new(2001, 2, 3)
    end
  end

  context "with an invalid attribute" do
    let(:attributes) { { name: nil, date: "today" } }

    it "raises an error" do
      expect { subject.attributes = attributes }
        .to raise_error(Mixture::CoercionError)
    end
  end
end
