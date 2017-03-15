module Renalware
  module AttributeNameHelper
    def attr_name(model, attr, suffix: nil)
      model.class.human_attribute_name(attr) + String(suffix)
    end
  end
end
