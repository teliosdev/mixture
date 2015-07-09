# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Hash class.
    class Hash < Base
      type Type::Hash

      coerce_to(Type::Object, Itself)
      coerce_to(Type::Hash, Itself)
      coerce_to(Type::Array, :to_a)
    end
  end
end
