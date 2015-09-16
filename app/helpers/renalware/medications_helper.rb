module Renalware
  module MedicationsHelper

    def medicatable_name(medication)
      if medication.medicatable.present?
        medication.medicatable.name
      else
        nil
      end
    end

    def highlight_validation_fail(med_object, med_attribute)
      if med_object.errors.include?(med_attribute)
        'field_with_errors'
      else
        nil
      end
    end

    def validation_fail(medication)
      medication.errors.any? ? 'show-form' : 'content'
    end

    def default_provider(provider)
      provider == 'gp' ? 'checked' : nil
    end

  end
end