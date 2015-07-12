# encoding: utf-8

module Mixture
  module Types
    # Represents a nil type.  This has no coercions.
    class Nil < Object
      options[:primitive] = ::NilClass
      as nil
    end
  end
end
