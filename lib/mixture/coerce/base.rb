# encoding: utf-8
# frozen_string_literal: true

require "singleton"

module Mixture
  module Coerce
    # The base for coercion actions.  Each action defines the "from"
    # type, and the instance handles the "to".
    class Base
      include Singleton

      # @overload type()
      #   Returns the type this instance corresponds to.
      #
      #   @return [Mixture::Type]
      # @overload type(value)
      #   Sets the type this instance corresponds to.
      #
      #   @param value [Mixture::Type]
      #   @return [void]
      def self.type(value = Undefined)
        if value == Undefined
          @_type
        else
          @_type = value
        end
      end

      # The coercions that this class has.  It's a map of the type
      # to the method that performs that coercion.
      #
      # @return [Hash{Mixture::Type => Symbol}]
      def self.coercions
        @_coercions ||= ThreadSafe::Hash.new
      end

      # This is a method that's called by ruby interally.  We're going
      # to use it to hook into the coercions, to allow a class
      # coercion.
      #
      # @param base [Class] A subclass.
      # @return [void]
      def self.inherited(base)
        super # for Singleton
        base.coerce_to(Types::Class) do |value, type|
          member = type.options.fetch(:members).first
          if member.respond_to?(:coerce) then member.coerce(value)
          elsif member.respond_to?(:new) then member.new(value)
          else
            fail CoercionError, "Expected #{member} to " \
                 "respond to #coerce, #new"
          end
        end
      end

      # This is a DSL for the class itself.  It essentially defines a
      # method to perform the coercion of the given type.
      #
      # @overload coerce_to(to) { }
      #   This is a DSL for the class itself.  It essentially defines
      #   a method to perform the coercion of the given type.
      #
      #   @param to [Mixture::Types::Type] The type to coerce to.
      #   @yield [value, type] The block is called with the value to
      #     coerce when coercion needs to happen.  Note that the
      #     block is not used as the body of the method - the method
      #     returns the block.
      #   @yieldparam value [Object] The object to coerce.
      #   @yieldparam type [Mixture::Types::Type] The destination type.
      #   @yieldreturn [Object] The coerced value.
      #   @return [void]
      #
      # @overload coerce_to(to, value)
      #   This is a DSL for the class itself.  It essentially defines
      #   a method to perform the coercion of the given type.
      #
      #   @param to [Mixture::Types::Type] The type to coerce to.
      #   @param value [Proc, Symbol] The block that is called with
      #     the value for coercion.  This block is returned by
      #     the defined coercion method.  If it's a symbol, it's
      #     turned into a block.  Note that this doesn't use
      #     Symbol#to_proc; it uses a similar block that ignores
      #     the excess paramters.
      #   @return [void]
      def self.coerce_to(to, data = Undefined, &block)
        fail ArgumentError, "Expected Mixture::Types::Type, got #{to}" unless
          to <= Mixture::Types::Type

        body = data_block(data, &block)
        coercions[to] = to.options[:method]
        define_method(to.options[:method]) { body }
      end

      # Turns a data/block given to {.coerce_to} into a block worthy
      # of a body for a method.
      #
      # @param data [Proc, Symbol] A proc/symbol to be used for a
      #   method.
      # @yield (see .coerce_to)
      # @yieldparam (see .coerce_to)
      # @yieldreturn (see .coerce_to)
      # @return [void]
      def self.data_block(data, &block)
        if data.is_a?(::Symbol)
          proc { |value| value.public_send(data) }
        elsif data.is_a?(::Proc)
          data
        elsif block_given?
          block
        else
          fail ArgumentError, "Expected a block, got #{data.inspect}"
        end
      end

      # (see #to)
      def self.to(type)
        instance.to(type)
      end

      # Returns a block to perform the coercion to the given type.
      # If it cannot find a coercion, it raises {CoercionError}.
      #
      # @param type [Mixture::Type] The type to coerce to.
      # @raise [CoercionError] If it could not find the coercion.
      # @return [Proc{(Object) => Object}]
      def to(type)
        coercions = self.class.coercions
        coercable = type.inheritable
                        .find { |ancestor| coercions.key?(ancestor) }
        unless coercable
          fail CoercionError, "Undefined coercion #{self.class.type} " \
            "=> #{type}"
        end

        public_send(coercions[coercable])
      end
    end
  end
end
