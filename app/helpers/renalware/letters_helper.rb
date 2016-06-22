module Renalware
  module LettersHelper
    def patient_letters_letters_path(patient, event=nil)
      if event.present?
        super(patient, event_type: event.class.to_s, event_id: event.id)
      else
        super(patient)
      end
    end

    def inline_observation(label, value, unit=nil)
      [
        content_tag(:strong, "#{label}: "),
        value,
        unit
      ].flatten.join(" ").html_safe
    end
  end
end

