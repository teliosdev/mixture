# encoding: utf-8
# frozen_string_literal: true

RSpec.describe Mixture::Coerce::Nil do
  subject { described_class.instance }

  it "performs coercions" do
    expect(subject.to_integer.call(nil)).to be 0
    expect(subject.to_boolean.call(nil)).to be false
    expect(subject.to_string.call(nil)).to eq ""
  end
end
