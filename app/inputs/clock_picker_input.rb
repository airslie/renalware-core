# frozen_string_literal: true

class ClockPickerInput < SimpleForm::Inputs::StringInput
  def input(_wrapper_options)
    template.tag.div(class: "relative rounded-md w-60") do
      template.concat prefix_column
      template.concat input_column
    end
  end

  def prefix_column(_wrapper_options = {})
    template.tag.div(class: "pointer-events-none absolute inset-y-0 left-0 flex items-center pl-2") do
      template.concat(icon_clock)
    end
  end

  def input_column(_wrapper_options = {})
    html_options = input_html_options
    html_options[:class] ||= []
    html_options[:class] << "border-0 !pl-10"

    html_options[:data] ||= {}
    html_options[:data].merge!(data_attributes)

    datestamp = @builder.object.public_send(attribute_name)
    value = datestamp.present? ? I18n.l(datestamp, format: :time) : ""

    @builder.text_field(attribute_name, html_options.merge(value: value))
  end

  def icon_clock
    '<svg xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 512 512"
      class="h-5 w-5"
      fill="currentColor">
        <path d="M240 112C240 103.2 247.2 96 256 96C264.8 96 272 103.2 272 112V247.4L360.9 306.7C368.2 311.6 370.2 321.5 365.3 328.9C360.4 336.2 350.5 338.2 343.1 333.3L247.1 269.3C242.7 266.3 239.1 261.3 239.1 256L240 112zM256 0C397.4 0 512 114.6 512 256C512 397.4 397.4 512 256 512C114.6 512 0 397.4 0 256C0 114.6 114.6 0 256 0zM32 256C32 379.7 132.3 480 256 480C379.7 480 480 379.7 480 256C480 132.3 379.7 32 256 32C132.3 32 32 132.3 32 256z"/>
      </svg>'.html_safe # rubocop:disable Rails/OutputSafety
  end

  def input_type
    :string
  end

  def data_attributes
    {
      controller: "flatpickr",
      flatpickr_time_only_value: true
    }
  end
end
