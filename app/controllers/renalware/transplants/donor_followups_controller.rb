# frozen_string_literal: true

require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class DonorFollowupsController < BaseController
      before_action :load_patient

      def show
        render locals: { patient: patient, donor_followup: operation.followup }
      end

      def new
        donor_followup = operation.build_followup
        render locals: { patient: patient, donor_followup: donor_followup }
      end

      def create
        donor_followup = operation.build_followup
        donor_followup.attributes = followup_attributes

        if donor_followup.save
          redirect_to patient_transplants_donor_dashboard_path(patient)
        else
          render :new, locals: { patient: patient, donor_followup: donor_followup }
        end
      end

      def edit
        render locals: { patient: patient, donor_followup: operation.followup }
      end

      def update
        donor_followup = operation.followup
        donor_followup.attributes = followup_attributes

        if donor_followup.save
          redirect_to patient_transplants_donor_dashboard_path(patient)
        else
          render :edit, locals: { patient: patient, donor_followup: donor_followup }
        end
      end

      protected

      def operation
        @operation ||= DonorOperation.find(params[:donor_operation_id])
      end

      def followup_attributes
        params
          .require(:transplants_donor_followup)
          .permit(attributes)
      end

      def attributes
        [
          :notes,
          :last_seen_on,
          :followed_up,
          :ukt_center_code,
          :lost_to_followup,
          :transferred_for_followup,
          :dead_on
        ]
      end
    end
  end
end
