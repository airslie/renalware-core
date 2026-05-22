module Renalware
  module System
    class SqlViewWidgetsController < BaseController
      def show
        authorize %i(renalware lab), :show?

        return head :not_found unless lab_widget_context_valid?

        render locals: {
          frame_id: frame_id,
          patient: patient_context,
          patient_scope: patient_scope_context,
          require_patient_scope: require_patient_scope?,
          view_metadata: view_metadata
        }
      end

      private

      def view_metadata
        @view_metadata ||= ViewMetadata.widgets.find(params[:id])
      end

      def lab_widget_context_valid?
        view_metadata.schema_name == params[:schema_name] &&
          view_metadata.widget_options.visible_in_slot?(slot) &&
          patient_slot_context_valid?
      end

      def frame_id
        "sql-view-widget-#{view_metadata.id}"
      end

      def patient_context
        return unless patient_slot?

        @patient_context ||= policy_scope(Patient)
          .find_by!(secure_id: params[:patient_id])
          .tap { |patient| authorize patient }
      end

      def patient_scope_context
        return if patient_slot?

        policy_scope(Patient).select(:id)
      end

      def require_patient_scope?
        patient_slot?
      end

      def patient_slot_context_valid?
        !patient_slot? || params[:patient_id].present?
      end

      def patient_slot?
        slot_segments.include?("patient")
      end

      def slot_segments
        slot.split(":")
      end

      def slot
        params[:slot].to_s
      end
    end
  end
end
