module Renalware
  module FormHelper
    def errors_css_class(model, attr)
      " field_with_errors" if model.errors.key?(attr)
    end

    def render_input(builder, attribute)
      class_name = builder.object.public_send(attribute).class.name.demodulize.underscore
      render "renalware/shared/documents/#{class_name}_input", attribute: attribute, f: builder
    end

    def monospace(value, width=5)
      content_tag(:span, class: "monospaced") do
        concat("%#{width}s" % value).gsub(/ /, "&nbsp;").html_safe
      end
    end
  end
end
