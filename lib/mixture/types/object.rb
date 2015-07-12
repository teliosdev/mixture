# encoding: utf-8

module Mixture
  module Types
    # An object.  This adds the basic constraints all types (that
    # inherit from Object) have; i.e., it must be an object, and
    # it must be the type's primitive.
    class Object < Type
      options[:primitive] = ::Object
      options[:method] = :to_object
      as :object

      constraint do |value|
        # This may seem a bit odd, but this returns false for
        # BasicObject; and since this is meant to represent Objects,
        # we want to make sure that the value isn't a BasicObject.
        # rubocop:disable Style/CaseEquality
        ::Object === value
        # rubocop:enable Style/CaseEquality
      end
      constraint { |value| value.is_a?(options[:primitive]) }
    end
  end
end
