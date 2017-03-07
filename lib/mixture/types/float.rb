# encoding: utf-8
# frozen_string_literal: true

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
