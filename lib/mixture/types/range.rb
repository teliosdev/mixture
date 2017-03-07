# encoding: utf-8
# frozen_string_literal: true

module Mixture
  module Types
    # The range type.
    class Range < Enumerable
      register
      options[:primitive] = ::Range
      options[:method] = :to_range
      as :range
    end
  end
end
