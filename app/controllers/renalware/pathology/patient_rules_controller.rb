require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class PatientRulesController < Pathology::BaseController
      before_filter :load_patient

      def new
        patient_rule = @patient.rules.new

        render_new(patient_rule)
      end

      def create
        patient_rule = @patient.rules.new(patient_rule_params)

        if patient_rule.save
          redirect_to patient_pathology_required_observations_path(@patient),
            notice: t(".success", model_name: "Patient Rule")
        else
          flash[:error] = t(".failed", model_name: "Patient Rule")
          render_new(patient_rule)
        end
      end

      def edit
        patient_rule = @patient.rules.find(params[:id])

        render_edit(patient_rule)
      end

      def update
        patient_rule = @patient.rules.find(params[:id])

        if patient_rule.update(patient_rule_params)
          redirect_to patient_pathology_required_observations_path(@patient),
            notice: t(".success", model_name: "patient rule")
        else
          flash[:error] = t(".failed", model_name: "patient rule")
          render_edit(patient_rule)
        end
      end

      def destroy
        RequestAlgorithm::PatientRule.destroy(params[:id])

        redirect_to patient_pathology_required_observations_path(@patient),
          notice: t(".success", model_name: "patient rule")
      end

      private

      def render_edit(patient_rule)
        render :edit, locals: {
          patient_rule: patient_rule,
          frequencies: find_frequencies,
          labs: find_labs
        }
      end

      def render_new(patient_rule)
        render :new, locals: {
          patient_rule: patient_rule,
          frequencies: find_frequencies,
          labs: find_labs
        }
      end

      def find_frequencies
        RequestAlgorithm::Frequency.all_names
      end

      def find_labs
        Lab.ordered
      end

      def patient_rule_params
        params
          .require(:pathology_request_algorithm_patient_rule)
          .permit(
            :patient_id,
            :lab_id,
            :test_description,
            :sample_number_bottles,
            :sample_type,
            :frequency_type,
            :start_date,
            :end_date
          )
      end
    end
  end
end
