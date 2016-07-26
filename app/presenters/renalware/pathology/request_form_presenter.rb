require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestFormPresenter < SimpleDelegator
      def patient_name
        patient.full_name.upcase
      end

      def date
        I18n.l Date.current
      end

      def date_of_birth
        I18n.l patient.born_on
      end

      def consultant
        request_form.consultant.full_name
      end

      def clinical_detail
        clinic.name
      end
      alias_method :contact, :clinical_detail

      def has_global_requests?
        global_requests_by_lab.any?
      end

      def has_patient_requests?
        patient_requests_by_lab.any?
      end

      def has_tests_required?
        global_requests_by_lab.any? || patient_requests_by_lab.any?
      end

      private

      def request_form
        __getobj__
      end
    end
  end
end
