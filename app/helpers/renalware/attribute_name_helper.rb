module Renalware
  module AttributeNameHelper
    # FIXME: Copied to Shared::Components::Base
    # disables :reek:FeatureEnvy
    def attr_name(model, attr, suffix: nil)
      klass = model.is_a?(Class) ? model : model.class
      klass.human_attribute_name(attr) + String(suffix)
    end
  end
end
