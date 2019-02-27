# frozen_string_literal: true

module Renalware
  module HD
    class PatientPolicy < Patients::PatientPolicy
      class Scope < Patients::PatientPolicy::Scope
        def patient_class
          Renalware::HD::Patient
        end
      end
    end
  end
end
