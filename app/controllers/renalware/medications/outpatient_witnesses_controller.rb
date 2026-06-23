module Renalware
  module Medications
    class OutpatientWitnessesController < BaseController
      def edit
        form = OutpatientWitnessForm.new(
          outpatient_prescription_administration_id: administration.id,
          user_id: administration.witnessed_by_id
        )
        render_edit(form)
      end

      def update
        form = OutpatientWitnessForm.new(
          form_params.merge(outpatient_prescription_administration_id: administration.id)
        )

        administration.skip_administrator_validation = true
        administration.skip_witness_validation = true if form.update_user_only

        if update_administration_from(form)
          # will render update.js
        else
          render_edit(form)
        end
      end

      private

      def update_administration_from(form)
        return unless form.valid?

        administration.witnessed_by_id = form.user_id
        administration.witnessed_by_password = form.password
        unless form.update_user_only
          administration.witness_authorised = true
          administration.signed_off_at = Time.current
        end
        administration.save_by(current_user)
      end

      def administration
        @administration ||= OutpatientPrescriptionAdministration
          .find(params[:outpatient_prescription_administration_id])
          .tap { |admin| authorize admin }
      end

      def render_edit(form)
        render(
          :edit,
          locals: { form:, administration: },
          layout: false
        )
      end

      def form_params
        params.require(:form).permit(:user_id, :password, :update_user_only)
      end
    end
  end
end
