# frozen_string_literal: true

require_dependency "renalware/renal"
require_dependency "renalware/renal/base_controller"

module Renalware
  module Renal
    class ProfilesController < BaseController
      include Renalware::Concerns::PatientVisibility

      def show
        render locals: {
          patient: patient,
          profile: find_and_authorize_profile
        }
      end

      def edit
        render locals: {
          patient: patient,
          profile: find_and_authorize_profile
        }
      end

      def update
        profile = find_and_authorize_profile

        if profile.update(profile_params)
          redirect_to patient_renal_profile_path(patient),
                      notice: success_msg_for("profile")
        else
          render :edit, locals: {
            patient: patient,
            profile: find_and_authorize_profile
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
            address_at_diagnosis_attributes: address_params, document: {}
          )
      end

      def address_params
        [
          :id, :name, :organisation_name, :street_1, :street_2, :street_3, :county, :country_id,
          :town, :postcode, :telephone, :email
        ]
      end

      def find_and_authorize_profile
        (patient.profile || patient.build_profile).tap { |profile| authorize profile }
      end
    end
  end
end
