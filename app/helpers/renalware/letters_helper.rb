require "base64"

module Renalware
  module LettersHelper
    def patient_letters_letters_path(patient, event=nil)
      if event.present?
        super(patient, event_type: event.class.to_s, event_id: event.id)
      else
        super(patient)
      end
    end

    def inline_value(label, value, unit=nil)
      [
        content_tag(:strong, "#{label}: "),
        value,
        unit
      ].flatten.join(" ").html_safe
    end

    def logo_image
      logo_filename = File.join(Rails.root, "/app/assets/images/NHS-Black.jpg")
      raw_data = File.read(logo_filename)
      data = Base64.encode64(raw_data)
      image_tag("data:image/jpeg;base64,#{data}", size: "82x33")
    end
  end
end

