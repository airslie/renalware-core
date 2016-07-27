module Renalware
  module PrescriptionsHelper
    def patient_prescriptions_path(patient, treatable=nil, params={})
      treatable ||= patient
      super(patient, params.merge(treatable_type: treatable.class.to_s, treatable_id: treatable.id))
    end

    def new_patient_prescription_path(patient, treatable=nil)
      treatable ||= patient
      super(patient, treatable_type: treatable.class.to_s, treatable_id: treatable.id)
    end

    def patient_medications_prescription_termination_path(patient, prescription, treatable=nil)
      treatable ||= patient
      super(patient, prescription, treatable_type: treatable.class.to_s, treatable_id: treatable.id)
    end

    def drug_name(prescription)
      prescription.drug.try!(:name)
    end

    def highlight_validation_fail(med_object, med_attribute)
      return unless med_object.errors.include?(med_attribute)

      "field_with_errors"
    end

    def validation_fail(prescription)
      prescription.errors.any? ? "show-form" : "content"
    end

    def default_provider(provider)
      provider == "gp" ? "checked" : nil
    end
  end
end
