# encoding: utf-8

module Mixture
  module Types
    # A single type.  A type is _never_ instantized; it is used as a
    # class to represent a type of value.
    class Type
      private_class_method :new
      private_class_method :allocate

      # The options for the type.  This is inherited by subtypes.
      #
      # @return [Hash{Symbol => Object}]
      def self.options
        @options ||= ThreadSafe::Hash.new
      end

      # Constraints on the type.  A value will not match the type if
      # any of these constraints fail.  This is inherited by subtypes.
      #
      # @return [Array<Proc{(Object) => Boolean}>]
      def self.constraints
        @constraints ||= ThreadSafe::Array.new
      end

      # Returns all of the names that this type can go under.  This is
      # used for {Types.mappings} and for inference.
      #
      # @see Types.mappings
      # @return [Array<Symbol, Object>]
      def self.mappings
        @mappings ||= ThreadSafe::Array.new
      end

      # Sets some names that this type can go under.  This is used
      # for {Type.mappings} and for inference.
      #
      # @see Types.mappings
      # @see .mappings
      # @param names [Symbol, Object]
      # @return [void]
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

      # Checks if the given value passes all of the constraints
      # defined on this type.  Each constraint is executed within the
      # context of the class, to provide access to {.options}.
      #
      # @param value [Object] The object to check.
      # @return [Boolean]
      def self.matches?(value)
        constraints.all? do |constraint|
          class_exec(value, &constraint)
        end
      end

      # Determines if this type is equal to another type.  This is
      # used by Ruby's hash, and is used to make an anonymous type
      # equal to its supertype (e.g.
      # `Types::Array[Types::Integer] == Types::Array`), mainly for
      # coercion.
      #
      # @param other [Object]
      # @return [Boolean]
      def self.eql?(other)
        if anonymous?
          superclass == other
        elsif other.respond_to?(:<=) && other <= Type && other.anonymous?
          other.superclass.eql?(self)
        else
          super
        end
      end

      # (see .eql?)
      def self.==(other)
        eql?(other)
      end

      # Used by ruby's Hash, this determines the hash of the type.  If
      # this is anonymous, it uses its supertype's hash.
      #
      # @see .eql?
      # @return [Numeric]
      def self.hash
        if anonymous?
          superclass.hash
        else
          super
        end
      end

      # If this class is anonymous.  This is counting on the fact that
      # the name of an anonymous class is nil; however, assigning a
      # class to a constant on initialization of a class will make
      # that class non-anonymous.
      #
      # @return [Boolean]
      def self.anonymous?
        name.nil?
      end

      # Inspects the class.  If the class is anonymous, it uses the
      # `:name` value in the options if it exists.  Otherwise, it
      # passes it up the chain.
      #
      # @return [String]
      def self.inspect
        if anonymous? && options.key?(:name)
          options[:name]
        else
          super
        end
      end

      # (see .inspect)
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
