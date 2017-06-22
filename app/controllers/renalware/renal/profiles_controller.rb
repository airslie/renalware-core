require_dependency "renalware/renal"
require_dependency "renalware/renal/base_controller"

module Renalware
  module Renal
    class ProfilesController < BaseController

      before_action :load_patient

      def show
        render locals: {
          patient: patient,
          profile: find_profile
        }
      end

      def edit
        render locals: {
          patient: patient,
          profile: find_profile
        }
      end

      def update
        profile = find_profile

        if profile.update_attributes(profile_params)
          redirect_to patient_renal_profile_path(patient),
            notice: t(".success", model_name: "profile")
        else
          render :edit, locals: {
            patient: patient,
            profile: find_profile
          }
        end
      end

      private

      def profile_params
        params
          .require(:renal_profile)
          .permit(
            :esrf_on, :first_seen_on, :prd_description_id, :weight_at_esrf,
            :modality_at_esrf, :comorbidities_updated_on,
            address_at_diagnosis_attributes: address_params
          )
          .merge(document: document_attributes)
      end

      def address_params
        [:id, :name, :organisation_name, :street_1, :street_2, :street_3, :county, :country,
          :town, :postcode, :telephone, :email]
      end

      def find_profile
        patient.profile || patient.build_profile
      end

      def document_attributes
        params
          .require(:renal_profile)
          .fetch(:document, nil)
          .try(:permit!)
      end
    end
  end
end
