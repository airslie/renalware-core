module Renalware
  module Patients
    class HeidiLinkedAccountsController < BaseController
      include Renalware::Concerns::PatientVisibility

      HEIDI_LINK_ACCOUNT_URI = URI(
        "https://registrar.scribe.heidihealth.com/integration/widget/auth"
      )

      def show
        authorize Renalware::Clinics::ClinicVisit, :create?
        authorize patient

        result = Renalware::Heidi::Client.new.linked_account_access(current_user)
        if result.success?
          render json: result.body
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

        HEIDI_LINK_ACCOUNT_URI.dup.tap { |safe_uri| safe_uri.query = uri.query }.to_s
      rescue KeyError, URI::InvalidURIError
        nil
      end

      def expected_heidi_link_account_uri?(uri)
        uri.scheme == HEIDI_LINK_ACCOUNT_URI.scheme &&
          uri.host == HEIDI_LINK_ACCOUNT_URI.host &&
          uri.path == HEIDI_LINK_ACCOUNT_URI.path
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
