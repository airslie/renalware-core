# frozen_string_literal: true

# A datepicker that uses tailwindcss instead of foundation.
# Could be improved by extracting to css class, but currently a proof of concept.
class DatePicker2Input < SimpleForm::Inputs::StringInput
  def input(_wrapper_options)
    template.tag.div(class: "mt-1 relative rounded-md shadow-sm") do
      template.concat prefix_column
      template.concat input_column
    end
  end

  # The calendar icon
  def prefix_column(_wrapper_options = {})
    "<div class='absolute inset-y-0 left-0 pl-2 flex items-center text-gray-600'>
      <svg xmlns='http://www.w3.org/2000/svg'
           class='h-6 w-6'
           fill='none'
           viewBox='0 0 24 24'
           stroke='currentColor'>
        <path
          stroke-linecap='round'
          stroke-linejoin='round'
          stroke-width='2'
          d='M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z'
        />
      </svg>
    </div>".html_safe
  end

  def input_column(_wrapper_options = {})
    html_options = input_html_options
    html_options[:class] ||= []
    html_options[:class] << class_name
    html_options[:class] << "block w-full pl-10 sm:text-sm rounded-md"
    html_options[:style] = "padding-left: 2.5rem; margin: 0; width: 10rem" # a hack for now
    datestamp = @builder.object.public_send(attribute_name)
    value = format_date(datestamp)
    @builder.text_field(attribute_name, html_options.merge(value: value))
  end

  def input_type
    :string
  end

  # Note this class is wired up with jquery to trigger the datepicker.
  # Perhaps move to stimulus?
  def class_name
    "datepicker2"
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
