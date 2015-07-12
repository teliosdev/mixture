# encoding: utf-8

module Mixture
  module Types
    class Boolean < Object
      options[:primitive] = nil
      as :bool, :boolean, true, false

      constraints.clear
      constraint do |value|
        [TrueClass, FalseClass].include?(value.class)
      end
    end
  end
end
