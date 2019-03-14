# frozen_string_literal: true

require_dependency "renalware/virology"

module Renalware
  module Virology
    class ProfilesController < Virology::BaseController
      def edit
        profile = find_profile
        authorize profile
        render_edit(profile: profile)
      end

      def update
        profile = find_profile
        authorize profile
        if update_profile(profile)
          redirect_to patient_virology_dashboard_path(patient)
        else
          render_edit(profile: profile)
        end
      end

      private

      def find_profile
        patient.profile || patient.build_profile
      end

      def render_edit(profile:)
        render :edit, locals: { patient: patient, profile: profile }
      end

      def update_profile(profile)
        document = profile.document
        document.hiv = year_date_diagnosis_for(:hiv)
        document.hepatitis_b = year_date_diagnosis_for(:hepatitis_b)
        document.hepatitis_b_core_antibody = year_date_diagnosis_for(:hepatitis_b_core_antibody)
        document.hepatitis_c = year_date_diagnosis_for(:hepatitis_c)
        document.htlv = year_date_diagnosis_for(:htlv)
        profile.save_by(current_user)
      end

      def year_date_diagnosis_for(condition)
        document_params = profile_params[:document]
        YearDatedDiagnosis.new(document_params[condition])
      end

      def profile_params
        params.require(:virology_profile).permit(document: {})
      end
    end
  end
end
