# encoding: utf-8

module Mixture
  module Types
    # The range type.
    class Range < Enumerable
      options[:primitive] = ::Range
      options[:method] = :to_range
      as :range
    end
  end
end
