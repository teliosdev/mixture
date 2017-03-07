# encoding: utf-8
# frozen_string_literal: true

module Mixture
  module Coerce
    # Handles coercion of the Object class.
    class Object < Base
      type Types::Object

      # Tries a set of methods on the object, before failing with a
      # coercion error.
      #
      # @return [Proc{(Symbol) => Proc{(Object) => Object}}]
      TryMethods = proc do |*methods|
        proc do |value|
          method = methods.find { |m| value.respond_to?(m) }
          fail CoercionError, "Could not coerce #{value.class}" unless method
          value.public_send(method)
        end
      end

      coerce_to(Types::Object, Itself)
      coerce_to(Types::Boolean, Prove)
      coerce_to(Types::Array, TryMethods[:to_a, :to_ary, :to_array])
      coerce_to(Types::Date, TryMethods[:to_date])
      coerce_to(Types::DateTime, TryMethods[:to_datetime])
      coerce_to(Types::Float, TryMethods[:to_f, :to_float])
      coerce_to(Types::Hash, TryMethods[:to_h, :to_hash])
      coerce_to(Types::Integer, TryMethods[:to_i, :to_integer])
      coerce_to(Types::Rational, TryMethods[:to_r, :to_rational])
      coerce_to(Types::Set, TryMethods[:to_set])
      coerce_to(Types::String, TryMethods[:to_s, :to_str, :to_string])
      coerce_to(Types::Symbol, TryMethods[:to_sym, :intern, :to_symbol])
      coerce_to(Types::Time, TryMethods[:to_time])
    end
  end
end
