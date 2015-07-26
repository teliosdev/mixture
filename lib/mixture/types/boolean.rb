# encoding: utf-8

module Mixture
  module Types
    # The boolean type.  Unfortunately, ruby doesn't have a clear cut
    # boolean primitive (it has `TrueClass` and `FalseClass`, but no
    # `Boolean` class), so we set the primitive to nil to prevent
    # odd stuff from happening.  It can still be matched by other
    # values.
    class Boolean < Object
      register
      options[:primitive] = nil
      as :bool, :boolean, true, false

      constraints.clear
      constraint do |value|
        [TrueClass, FalseClass].include?(value.class)
      end
    end
  end
end
