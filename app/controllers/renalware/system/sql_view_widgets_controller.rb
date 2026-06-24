module Renalware
  module System
    class SqlViewWidgetsController < BaseController
      def show
        authorize_widget_access

        return head :not_found unless widget_context_valid?

        render locals: {
          frame_id: frame_id,
          lab: lab_slot?,
          patient: patient_context,
          patient_scope: patient_scope_context,
          require_patient_scope: require_patient_scope?,
          view_metadata: view_metadata
        }
      end

      private

      def authorize_widget_access
        return authorize %i(renalware lab), :show? if lab_slot?

        authorize view_metadata
      end

      def view_metadata
        @view_metadata ||= ViewMetadata.widgets.find(params[:id])
      end

      def widget_context_valid?
        view_metadata.schema_name == params[:schema_name] &&
          view_metadata.widget_options.visible_in_slot?(slot) &&
          patient_slot_context_valid?
      end

      def frame_id
        "sql-view-widget-#{view_metadata.id}"
      end

      def patient_context
        return if params[:patient_id].blank?

        @patient_context ||= policy_scope(Patient)
          .find_by!(secure_id: params[:patient_id])
          .tap { |patient| authorize patient }
      end

      def patient_scope_context
        return if patient_context.present?

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

      def lab_slot?
        slot_segments.first == "lab"
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
