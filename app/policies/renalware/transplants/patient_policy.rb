# frozen_string_literal: true

module Renalware
  module Transplants
    class PatientPolicy < Patients::PatientPolicy
      class Scope < Patients::PatientPolicy::Scope
        def patient_class
          Transplants::Patient
        end
      end
    end
  end
end
