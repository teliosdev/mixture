# encoding: utf-8

module Mixture
  module Types
    # A float.  Not much to say here.
    class Float < Numeric
      register
      options[:primitive] = ::Float
      options[:method] = :to_float
      as :float
    end
  end
end
