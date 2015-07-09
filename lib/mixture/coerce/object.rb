# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Object class.
    class Object < Base
      type Type::Object

      TryMethods = proc do |*methods|
        proc do |value|
          method = methods.find { |m| value.respond_to?(m) }
          if method
            value.public_send(method)
          else
            fail CoercionError, "Could not coerce #{value.class}"
          end
        end
      end

      coerce_to(Type::Array, TryMethods[:to_a, :to_ary, :to_array])
      coerce_to(Type::Date, TryMethods[:to_date])
      coerce_to(Type::DateTime, TryMethods[:to_datetime])
      coerce_to(Type::Float, TryMethods[:to_f, :to_float])
      coerce_to(Type::Hash, TryMethods[:to_h, :to_hash])
      coerce_to(Type::Integer, TryMethods[:to_i, :to_integer])
      coerce_to(Type::Object, :dup)
      coerce_to(Type::Rational, TryMethods[:to_r, :to_rational])
      coerce_to(Type::Set, TryMethods[:to_set])
      coerce_to(Type::String, TryMethods[:to_s, :to_str, :to_string])
      coerce_to(Type::Symbol, TryMethods[:to_sym, :intern, :to_symbol])
      coerce_to(Type::Time, TryMethods[:to_time])
    end
  end
end
