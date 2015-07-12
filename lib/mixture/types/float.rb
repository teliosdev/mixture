# encoding: utf-8

module Mixture
  module Types
    class Float < Numeric
      options[:primitive] = ::Float
      options[:method] = :to_float
      as :float
    end
  end
end
