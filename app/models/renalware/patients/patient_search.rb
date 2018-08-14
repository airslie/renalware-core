# frozen_string_literal: true

module Renalware
  module Patients
    class PatientSearch
      def self.call(params)
        Renalware::Patient
          .includes(current_modality: [:description])
          .search(params[:patient_search]).tap do |search|
          search.sorts = %w(family_name given_name)
        end
      end
    end
  end
end
