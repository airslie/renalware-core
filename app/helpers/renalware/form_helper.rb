# frozen_string_literal: true

module Renalware
  module FormHelper
    def errors_css_class(model, attr)
      " field_with_errors" if model.errors.key?(attr)
    end

    def render_input(builder, attribute, html_options: {})
      renderable = builder.object.public_send(attribute)
      return unless renderable

      render input_partial_path_for(renderable),
             attribute: attribute,
             f: builder,
             html_options: html_options
    end

    def input_partial_path_for(renderable)
      partial_type = partial_type_for(renderable)
      "renalware/shared/documents/#{partial_type}_input"
    end

    def partial_type_for(renderable)
      if renderable.respond_to?(:to_partial_path)
        renderable.to_partial_path.split("/").last
      else
        renderable.class.name.demodulize.underscore
      end
    end

    def monospace(value, width = 5)
      tag.span(class: "monospaced") do
        concat("%#{width}s" % value).gsub(/ /, "&nbsp;").html_safe
      end
    end

    def save_or_cancel(
      form:,
      back_path:,
      submit_title: I18n.t("btn.save"),
      cancel_title: I18n.t("btn.cancel")&.downcase
    )
      capture do
        concat(form.submit(submit_title, class: "button"))
        concat(tag.span { " #{I18n.t('btn.or')} " })
        concat(link_to(cancel_title, back_path))
      end
    end
  end
end
