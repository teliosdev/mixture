# encoding: utf-8

module Mixture
  module Extensions
    # Has the mixture have attributes.
    module Attributable
      # The class methods for attribution.
      module ClassMethods
        def attribute(name, options)
          name = name.to_s.intern
          attributes[name] = Attribute.new(name, options)
        end

        def attributes
          @_attributes ||= {}
        end
      end

      # The instance methods for attribution.
      module InstanceMethods
        private

        # Sets the attributes on the instance.
        def __attributes__(attrs)
          attrs.each { |key, value| attribute(key, value) }
        end
        alias_method :attributes, :__attributes__

        def __unknown_attribute__(attr)
          fail ArgumentError, "Unknown attribute #{attr} passed"
        end
        alias_method :unknown_attribute, :__unknown_attribute__

        def __attribute__(key, value)
          attr = self.class.attributes.fetch(key) do
            return unknown_attribute(key)
          end

          value = coerce_attribute(attr, value) if
                    respond_to?(:coerce_attribute)
          instance_variable_set(:"@#{attr.name}", value)
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
