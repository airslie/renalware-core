module Renalware
  module Patients
    class PatientSearch
      def self.call(params)
        Renalware::Patient
          .includes(current_modality: [:description])
          .search(params[:q]).tap do |search|
          search.sorts = %w(family_name given_name)
        end
      end
    end
  end
end
