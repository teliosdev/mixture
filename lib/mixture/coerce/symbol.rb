# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Numeric class.
    class Symbol < Base
      type Type::Symbol

      coerce_to(Type::Object, Itself)
      coerce_to(Type::String, :to_s)
      coerce_to(Type::Symbol, Itself)
    end
  end
end
