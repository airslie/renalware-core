# frozen_string_literal: true

module Renalware
  module DefinitionListHelper
    class DefinitionList < SimpleDelegator
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::TextHelper
      include ActionView::Context

      def initialize(model)
        @model_klass = model.class
        super(model)
      end

      def definition(attribute, label = nil)
        text = label || @model_klass.human_attribute_name(attribute)
        value = public_send(attribute)
        value = yield(value) if value.present? && block_given?
        capture do
          concat content_tag(:dt, text)
          concat content_tag(:dd, value)
        end
      end
    end

    def definition_list_for(model, size: :large)
      content_tag(:dl, class: "dl-horizontal #{size}") do
        yield DefinitionList.new(model)
      end
    end
  end
end
