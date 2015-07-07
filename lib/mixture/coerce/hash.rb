# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Hash class.
    class Hash < Base
      type Type::Hash

      coerce_to(Type::String, &:to_s)
    end
  end
end
