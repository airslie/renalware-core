module Renalware
  module LettersHelper
    def patient_letters_letters_path(patient, event=nil)
      if event.present?
        super(patient, event_type: event.class.to_s, event_id: event.id)
      else
        super(patient)
      end
    end
  end
end

