# frozen_string_literal: true

# DSL to document the accepted attributes.
#
#   class CreateUser < Actor
#     input :name
#     output :name
#   end
module ServiceActor::Attributable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def inherited(child)
      super

      child.inputs.merge!(inputs)
      child.outputs.merge!(outputs)
    end

    def input(name, **arguments)
      validate_input_arguments(arguments)

      inputs[name] = arguments

      define_method(name) do
        result[name]
      end

      # For avoid method redefined warning messages.
      alias_method name, name if method_defined?(name)

      protected name
    end

    def inputs
      @inputs ||= {}
    end

    def output(name, **arguments)
      outputs[name] = arguments

      define_method(name) do
        result[name]
      end

      define_method("#{name}=") do |value|
        result[name] = value
      end

      protected name, "#{name}="
    end

    def outputs
      @outputs ||= {}
    end

    private

    def validate_input_arguments(arguments)
      return unless arguments.key?(:type)

      type_definition = if arguments[:type].is_a?(Hash)
                          arguments[:type][:is]
                        else
                          arguments[:type]
                        end

      Array(type_definition).each do |type_argument|
        ServiceActor::ArgumentsValidator.validate_module(type_argument)
      end
    end
  end
end
