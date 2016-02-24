module Renalware
  module MedicationsHelper
    def patient_medications_path(patient, treatable=nil)
      treatable ||= patient
      super(patient, treatable_type: treatable.class.to_s, treatable_id: treatable.id)
    end

    def new_patient_medication_path(patient, treatable=nil)
      treatable ||= patient
      super(patient, treatable_type: treatable.class.to_s, treatable_id: treatable.id)
    end

    def medication_sort_link(treatable, query, attribute, label, *args)
      if treatable.sortable?
        sort_link(query, attribute, label, *args)
      else
        label
      end
    end

    def drug_name(medication)
      if medication.drug.present?
        medication.drug.name
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
