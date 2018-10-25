# frozen_string_literal: true

class DatePickerInput < SimpleForm::Inputs::StringInput
  # Note that where we use `wrapper: :clockpicker` or `wrapper: horizontal_clockpicker`,
  # #input is not called and we call #prefix_column and #input_column directly.
  def input(_wrapper_options)
    template.content_tag(:div, class: "row collapse #{class_name}-wrapper") do
      template.concat prefix_column
      template.concat input_column
    end
  end

  def prefix_column(_wrapper_options = {})
    template.content_tag(:div, class: "small-2 columns") do
      template.concat icon_calendar
    end
  end

  # rubocop:disable Metrics/AbcSize
  def input_column(_wrapper_options = {})
    html_options = input_html_options
    html_options[:class] ||= []
    html_options[:class] << class_name
    template.content_tag(:div, class: "small-10 columns") do
      datestamp = @builder.object.public_send(attribute_name)
      value = format_date(datestamp)
      template.concat @builder.text_field(attribute_name, html_options.merge(value: value))
    end
  end
  # rubocop:enable Metrics/AbcSize

  def icon_calendar
    "<span class='prefix'><i class='far fa-calendar'></i></span>".html_safe
  end

  def input_type
    :string
  end

  def class_name
    "datepicker"
  end

  private

  # Note that datestamp will be some kind of Date object *unless* its an invalid date string
  # e.g. "12-00-2010" that has for example been imported from another system, and its one we
  # happen to store in Rw2 in jsonb where there is no database type checking.
  # We have seen this in LowClerance::Profile.document.
  # So if we get an error converting an invalid date string, return it as is and let the
  # user correct it in the UI. Note that without this error handling, the user will
  # not be able to view the form to correct the data.
  def format_date(datestamp)
    return "" if datestamp.blank?

    I18n.l(datestamp)
  rescue I18n::ArgumentError # e.g. its a string containing an invalid date
    datestamp
  end
end
