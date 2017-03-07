# encoding: utf-8
# frozen_string_literal: true

module Mixture
  module Extensions
    # Has the mixture have attributes.
    module Attributable
      # The class methods for attribution.
      module ClassMethods
        # Defines an attribute.  Defines the getter and the setter for
        # for the attribute, the getter and setter alias to the
        # {#attribute}.
        #
        # @param name [Symbol] The name of the attribute.
        # @param options [Hash] The options for the attribute.
        # @return [Attribute] The new attribute.
        def attribute(name, options = {})
          name = name.to_s.intern
          attr = attributes.create(name, options)
          define_method(attr.getter) {     attribute(name)    } unless
            options[:wo] || options[:write_only]
          define_method(attr.setter) { |v| attribute(name, v) } unless
            options[:ro] || options[:read_only]
          attr
        end

        # The attribute list.  Acts as a hash for the attributes.
        #
        # @see AttributeList
        # @return [AttributeList]
        def attributes
          return @_attributes if @_attributes
          available = ancestors[1..-1]
                      .select { |c| c.respond_to?(:attributes) }
                      .first
          parent = available ? available.attributes : nil
          @_attributes = AttributeList.new(parent)
        end
      end

      # The instance methods for attribution.
      module InstanceMethods
        # Sets the attributes on the instance.  It iterates through
        # the given hash and uses {#attribute} to set the key, value
        # pair.
        #
        # @param attrs [Hash] The attributes to set.
        # @return [void]
        def attributes=(attrs)
          attrs.each { |key, value| attribute(key, value) }
        end

        # The attributes defined on this instance.  It returns a
        # hash containing the key-value pairs for each attribute.
        #
        # @return [Hash{Symbol => Object}]
        def attributes
          Hash[self.class.attributes.map do |name, attr|
            [name, instance_variable_get(attr.ivar)]
          end]
        end

        # Called when an unknown attribute is accessed using
        # {#attribute}.  By default, it just raises an `ArgumentError`.
        #
        # @param attr [Symbol] The attribute.
        # @raise [ArgumentError]
        def unknown_attribute(attr)
          fail ArgumentError, "Unknown attribute #{attr} passed"
        end

        # @overload attribute(key)
        #   Accesses an attribute by the given key name.  If the
        #   attribute could not be found, it calls
        #   {#unknown_attribute}.  It uses the instance variable value
        #   of the attribute as the value of the attribute (e.g. it
        #   uses `@name` for the `name` attribute).
        #
        #   @param key [Symbol] The name of the attribute.
        #   @return [Object] The value of the attribute.
        # @overload attribute(key, value)
        #   Sets an attribute value by the given key name.  If the
        #   attribute could not be found, it calls
        #   {#unknown_attribute}.  It calls any of the update
        #   callbacks via {Attribute#update}, and sets the instance
        #   variable for the attribute.
        #
        #   @param key [Symbol] The name of the attribute.
        #   @param value [Object] The new value of the attribute.
        #   @return [void]
        def attribute(key, value = Undefined)
          attr = self.class.attributes.fetch(key) do
            return unknown_attribute(key)
          end

          return instance_variable_get(attr.ivar) if value == Undefined

          value = attr.update(value)
          instance_variable_set(attr.ivar, value)
        end
      end

      # Called by Ruby when the module is included.  This just
      # extends the base by the {ClassMethods} module and includes
      # into the base the {InstanceMethods} module.
      #
      # @param base [Object]
      # @return [void]
      # @api private
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end
    end
  end
end
