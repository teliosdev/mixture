# encoding: utf-8
# frozen_string_literal: true

module Mixture
  module Coerce
    # Handles coercion of the Numeric class.
    class Symbol < Base
      type Types::Symbol

      coerce_to(Types::Object, Itself)
      coerce_to(Types::String, :to_s)
      coerce_to(Types::Symbol, Itself)
    end
  end
end
