module Renalware
  module Patients
    class HeidiLinkedAccountsController < BaseController
      include Renalware::Concerns::PatientVisibility

      def show
        authorize Renalware::Clinics::ClinicVisit, :create?
        authorize patient

        result = Renalware::Heidi::Client.new.linked_account_access(current_user)
        if result.success?
          render json: { is_linked: result.body["is_linked"] == true }
        else
          render json: { is_linked: false, error: result.error }, status: :bad_gateway
        end
      end

      def new
        redirect_to_linking_flow
      end

      def create
        redirect_to_linking_flow
      end

      private

      def redirect_to_linking_flow
        authorize Renalware::Clinics::ClinicVisit, :create?
        authorize patient

        result = Renalware::Heidi::Client.new.link_account_url_for(current_user)
        if result.success?
          if (url = heidi_link_account_redirect_url(result))
            redirect_to url, allow_other_host: true
          else
            redirect_to_failed_linking("Heidi account linking returned an invalid setup URL")
          end
        else
          redirect_to_failed_linking(result.error)
        end
      end

      def heidi_link_account_redirect_url(result)
        url = result.body.fetch("url")
        uri = URI.parse(url)
        return unless expected_heidi_link_account_uri?(uri)

        configured_heidi_link_account_uri.dup.tap { |safe_uri| safe_uri.query = uri.query }.to_s
      rescue KeyError, URI::InvalidURIError
        nil
      end

      def expected_heidi_link_account_uri?(uri)
        expected_uri = configured_heidi_link_account_uri
        uri.scheme == expected_uri.scheme &&
          uri.host == expected_uri.host &&
          uri.path == expected_uri.path
      end

      def configured_heidi_link_account_uri
        Renalware::Heidi::Client.link_account_uri
      end

      def redirect_to_failed_linking(error)
        redirect_to patient_lab_path(patient),
                    alert: t(
                      "renalware.patients.heidi_linked_accounts.create.failed",
                      error:
                    )
      end
    end
  end
end
