module Renalware
  module AttributeNameHelper
    # disables :reek:FeatureEnvy
    def attr_name(model, attr, suffix: nil)
      klass = model.is_a?(Class) ? model : model.class
      klass.human_attribute_name(attr) + String(suffix)
    end
  end

  # A WIP experiment to create a better way of generating attribute names from I18n
  # using the underlying human_attribute_name.
  # Not convinced yet this is worth added complexity but the idea to access labels eg for
  # table headers like so:
  #   PatientLabels.name
  #   PatientLabels.nhs_number
  #
  # class PatientLabels
  #   class << self
  #     # disables :reek:BooleanParameter
  #     def method_missing(method, *_args, &block)
  #       Renalware::Patient.human_attribute_name(method.to_sym) || super
  #     end

  #     def respond_to_missing?(_method_name, _include_private = false)
  #       true
  #     end

  #     def name
  #       method_missing(:name)
  #     end
  #   end
  # end
end
