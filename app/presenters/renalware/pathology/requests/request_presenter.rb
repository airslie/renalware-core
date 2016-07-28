require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class RequestPresenter < SimpleDelegator
        def self.present(requests)
          requests.map { |request| new request }
        end

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

        private

        def request_form
          __getobj__
        end
      end
    end
  end
end
