class DatePickerInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    template.content_tag(:div, class: "row collapse datepicker-wrapper") do
      template.concat prefix_column
      template.concat input_column
    end
  end

  def prefix_column
    template.content_tag(:div, class: "large-2 columns") do
      template.concat icon_calendar
    end
  end

  def input_column
    html_options = input_html_options
    html_options[:class] ||= []
    html_options[:class] << class_name
    template.content_tag(:div, class: "large-10 columns") do
      datestamp = @builder.object.send(attribute_name)
      value = datestamp.present? ? I18n.l(datestamp) : ""
      template.concat @builder.text_field(attribute_name, html_options.merge(value: value))
    end
  end

  def icon_calendar
    "<span class='prefix'><i class='fi-calendar'></i></span>".html_safe
  end

  def input_type
    :string
  end

  def class_name
    "datepicker"
  end
end
