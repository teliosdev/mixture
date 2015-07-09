# encoding: utf-8

RSpec.describe Mixture::Type do
  IsAType = proc { it { is_expected.to be_a Mixture::Type } }
  describe Mixture::Type::Boolean, &IsAType
  describe Mixture::Type::Nil, &IsAType
  describe Mixture::Type::Array, &IsAType
  describe Mixture::Type::Date, &IsAType
  describe Mixture::Type::DateTime, &IsAType
  describe Mixture::Type::Float, &IsAType
  describe Mixture::Type::Hash, &IsAType
  describe Mixture::Type::Integer, &IsAType
  describe Mixture::Type::Object, &IsAType
  describe Mixture::Type::Rational, &IsAType
  describe Mixture::Type::Set, &IsAType
  describe Mixture::Type::String, &IsAType
  describe Mixture::Type::Symbol, &IsAType
  describe Mixture::Type::Time, &IsAType
end
