# frozen_string_literal: true

class ClockPickerInput < SimpleForm::Inputs::StringInput
  # Note that where we use `wrapper: :clockpicker` or `wrapper: horizontal_clockpicker`,
  # #input is not called and we call #prefix_column and #input_column directly.
  def input(_wrapper_options)
    template.content_tag(:div, class: "row collapse #{class_name}-wrapper") do
      template.concat prefix_column
      template.concat input_column
    end
  end

  def prefix_column(_wrapper_options = {})
    template.content_tag(:div, class: "small-3 input-group-addon columns") do
      template.concat(icon_clock)
    end
  end

  def input_column(_wrapper_options = {})
    html_options = input_html_options
    html_options[:class] ||= []
    html_options[:class] << class_name
    template.content_tag(:div, class: "small-9 columns") do
      datestamp = @builder.object.public_send(attribute_name)
      value = datestamp.present? ? I18n.l(datestamp, format: :time) : ""
      template.concat @builder.text_field(attribute_name, html_options.merge(value: value))
    end
  end

  def icon_clock
    "<span class='prefix'><i class='fa fa-clock-o'></i></span>".html_safe
  end

  def input_type
    :string
  end

  def class_name
    "clockpicker"
  end
end
