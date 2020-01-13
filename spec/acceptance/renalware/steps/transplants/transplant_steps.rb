# frozen_string_literal: true

module Renalware::Transplants::TransplantSteps
  def transplant_patient
    @transplant_patient ||= Renalware::Transplants.cast_patient(patient)
  end
end
