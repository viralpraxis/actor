# frozen_string_literal: true

module ServiceActor::ArgumentsValidator
  module_function

  def validate_module(value, string_resolution: true)
    return if value.is_a?(Module)
    return if string_resolution && value.is_a?(String) &&
              Object.const_defined?(value)

    raise ArgumentError, "Expected #{value} to be a module or a module name"
  end

  def validate_error_class(value)
    return if value.is_a?(Class) && value <= Exception

    raise ArgumentError, "Expected #{value} to be a subclass of Exception"
  end
end
