# encoding: utf-8

module Mixture
  module Types
    class Enumerable < Object
      options[:primitive] = ::Enumerable
      constraint do |value|
        # include Enumerable adds Enumerable to the ancestors list.
        value.class.ancestors.include?(::Enumerable)
      end
    end
  end
end
