# encoding: utf-8

module Mixture
  module Types
    # A single type.
    class Type
      private_class_method :new

      def self.options
        @options ||= ThreadSafe::Hash.new
      end

      def self.constraints
        @constraints ||= ThreadSafe::Array.new
      end

      def self.mappings
        @mappings ||= ThreadSafe::Array.new
      end

      def self.as(*names)
        mappings.concat(names)
      end

      # Called by ruby when a class inherits this class.  This just
      # propogates the options and constraints to the new subclass.
      #
      # @param sub [Class] The new subclass.
      # @return [void]
      def self.inherited(sub)
        Types.types << sub unless sub.anonymous?
        sub.options.merge!(options)
        sub.constraints.concat(constraints)
      end

      def self.matches?(value)
        constraints.all? do |constraint|
          class_exec(value, &constraint)
        end
      end

      def self.eql?(other)
        if anonymous?
          superclass == other
        elsif other.respond_to?(:<=) && other <= Type && other.anonymous?
          other.superclass.eql?(self)
        else
          super
        end
      end

      def self.==(other)
        eql?(other)
      end

      def self.hash
        if anonymous?
          superclass.hash
        else
          super
        end
      end

      def self.anonymous?
        name.nil?
      end

      def self.inspect
        if anonymous? && options.key?(:name)
          options[:name]
        else
          super
        end
      end

      def self.to_s
        inspect
      end

      # This is used to determine if a specific object is this type.
      # There can be many constraints, and they're all used to check
      # the given object.
      #
      # @note Constraints are not meant for _validation_.  Constraints
      #   are **purely** meant for identification, and should be used
      #   as such.
      #
      # @overload self.constraint(value)
      #   Adds the value as a constraint.  Ideally, this should
      #   respond to `#call`.
      #
      #   @example Subclass constraint.
      #     constraint(->(value) { value.is_a?(String) })
      #   @param value [#call] The constraint to add.
      #   @return [void]
      #
      # @overload self.constraint(&block)
      #   Adds the block as a constraint.
      #
      #   @example Subclass constraint.
      #     constraint { |value| value.is_a?(String) }
      #   @yield [value]
      #   @yieldparam value [Object] The value to check.
      #   @yieldreturn [Boolean] If the constraint was passed.
      #   @return [void]
      def self.constraint(value = Undefined, &block)
        if block_given?
          constraints << block
        elsif value != Undefined
          constraints << value
        else
          fail ArgumentError, "Expected an argument or a block, " \
            "got neither"
        end
      end
    end
  end
end
