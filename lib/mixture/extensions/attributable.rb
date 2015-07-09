# encoding: utf-8

module Mixture
  module Extensions
    # Has the mixture have attributes.
    module Attributable
      # The class methods for attribution.
      module ClassMethods
        def attribute(name, options = {})
          name = name.to_s.intern
          attr = attributes.create(name, options)
          define_method(attr.getter) {     attribute(name)    }
          define_method(attr.setter) { |v| attribute(name, v) }
          attr
        end

        def attributes
          @_attributes ||= AttributeList.new
        end
      end

      # The instance methods for attribution.
      module InstanceMethods
        # Sets the attributes on the instance.
        def attributes=(attrs)
          attrs.each { |key, value| attribute(key, value) }
        end

        def attributes
          Hash[self.class.attributes.map do |name, attr|
            [name, instance_variable_get(attr.ivar)]
          end]
        end

        def unknown_attribute(attr)
          fail ArgumentError, "Unknown attribute #{attr} passed"
        end

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
