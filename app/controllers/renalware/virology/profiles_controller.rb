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
        document_params = profile_params[:document]
        document = profile.document
        document.hiv = YearDatedDiagnosis.new(document_params[:hiv])
        document.hepatitis_b = YearDatedDiagnosis.new(document_params[:hepatitis_b])
        document.hepatitis_c = YearDatedDiagnosis.new(document_params[:hepatitis_c])
        document.htlv = YearDatedDiagnosis.new(document_params[:htlv])
        profile.save_by(current_user)
      end

      def profile_params
        params
          .require(:virology_profile)
          .permit(attributes)
          .merge(document: document_attributes)
      end

      def attributes
        [
          document: []
        ]
      end

      def document_attributes
        params.require(:virology_profile).fetch(:document, nil).try(:permit!)
      end
    end
  end
end
