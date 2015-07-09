# encoding: utf-8

require "forwardable"

module Mixture
  module Extensions
    # Has the mixture respond to `#[]` and `#[]=`.
    module Hashable
      extend Forwardable
      include Enumerable
      include Comparable

      delegate [:each, :<=>] => :attributes

      # Alias for {Attributable::InstanceMethods#attribute}.
      #
      # @param (see Attributable::InstanceMethods#attribute)
      # @return (see Attributable::InstanceMethods#attribute)
      def [](key)
        attribute(key.to_s.intern)
      end

      # Alias for {Attributable::InstanceMethods#attribute}.
      #
      # @param (see Attributable::InstanceMethods#attribute)
      # @return (see Attributable::InstanceMethods#attribute)
      def []=(key, value)
        attribute(key.to_s.intern, value)
      end

      # Checks for an attribute with the given name.
      #
      # @param key [Symbol] The name of the attribute to check.
      # @return [Boolean]
      def key?(key)
        self.class.attributes.key?(key.to_s.intern)
      end

      # @overload fetch(key)
      #   Performs a fetch.  This acts just like Hash's `fetch`.
      #
      #   @param key [Symbol] The key to check for an attribute.
      #   @raise [KeyError] If the key isn't present.
      #   @return [Object] The attribute's value.
      # @overload fetch(key, default)
      #   Performs a fetch.  This acts just like Hash's fetch.  If
      #   the attribute doesn't exist, the default argument value is
      #   used as a value instead.
      #
      #   @param key [Symbol] The key to check for an attribute.
      #   @param default [Object] The value to use instead of an
      #     error.
      #   @return [Object] The attribute's value, or the default value
      #     instead.
      # @overload fetch(key) { }
      #   Performs a fetch.  This acts just like Hash's fetch.  If
      #   the attribute doesn't exist, the value of the block is used
      #   as a value instead.
      #
      #   @param key [Symbol] The key to check for an attribute.
      #   @yield [key] The block is called if an attribute does not
      #     exist.
      #   @yieldparam key [Symbol] The key of the non-existant
      #     attribute.
      #   @yieldreturn [Object] Return value of the method.
      #   @return [Object] The attribute's value, or the block's
      #     value instead.
      def fetch(key, default = Unknown)
        case
        when key?(key.to_s.intern) then attribute(key.to_s.intern)
        when block_given?          then yield(key.to_s.intern)
        when default != Unknown    then default
        else fail KeyError, "Undefined attribute #{key.to_s.intern}"
        end
      end
    end
  end
end
