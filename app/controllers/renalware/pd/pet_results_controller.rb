# frozen_string_literal: true

require_dependency "renalware/pd"

module Renalware
  module PD
    class PETResultsController < BaseController
      def new
        pet = PETResult.new(patient: patient, performed_on: Date.current)
        authorize pet
        render_new(pet)
      end

      def create
        pet = PETResult.new(pet_result_params)
        authorize pet

        if pet.save_by(current_user)
          redirect_to patient_pd_dashboard_path(patient), notice: success_msg_for("PET result")
        else
          render_new(pet)
        end
      end

      def edit
        render locals: { pet: find_authorize_pet_result }
      end

      def update
        pet = find_authorize_pet_result
        if pet.update_by(current_user, pet_result_params)
          redirect_to patient_pd_dashboard_path(patient), notice: success_msg_for("PET result")
        else
          render_edit(pet)
        end
      end

      private

      def find_authorize_pet_result
        PD::PETResult.for_patient(patient).find(params[:id]).tap do |pet|
          authorize pet
        end
      end

      def render_edit(pet)
        render :edit, locals: { pet: pet }
      end

      def render_new(pet)
        render :new, locals: { pet: pet }
      end

      # rubocop:disable Metrics/MethodLength
      def pet_result_params
        params
          .require(:pd_pet_result)
          .permit(
            :patient_id,
            :performed_on,
            :test_type,
            :volume_in,
            :volume_out,
            :dextrose,
            :infusion_time,
            :drain_time,
            :overnight_volume_in,
            :overnight_volume_out,
            :overnight_dextrose,
            :overnight_dwell_time
          )
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
