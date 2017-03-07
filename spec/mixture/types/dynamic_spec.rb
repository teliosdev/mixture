# encoding: utf-8
# frozen_string_literal: true

RSpec.describe Mixture::Types do
  IsAType = proc do
    subject { described_class }
    it { is_expected.to be <= Mixture::Types::Type }
  end

  describe Mixture::Types::Boolean, &IsAType
  describe Mixture::Types::Nil, &IsAType
  describe Mixture::Types::Array, &IsAType
  describe Mixture::Types::Date, &IsAType
  describe Mixture::Types::DateTime, &IsAType
  describe Mixture::Types::Float, &IsAType
  describe Mixture::Types::Hash, &IsAType
  describe Mixture::Types::Integer, &IsAType
  describe Mixture::Types::Object, &IsAType
  describe Mixture::Types::Rational, &IsAType
  describe Mixture::Types::Set, &IsAType
  describe Mixture::Types::String, &IsAType
  describe Mixture::Types::Symbol, &IsAType
  describe Mixture::Types::Time, &IsAType
end
