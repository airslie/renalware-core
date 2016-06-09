require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class PatientRulesController < Pathology::BaseController
      before_filter :load_patient

      def new
        frequencies = RequestAlgorithm::Frequency.all
        labs = Lab.ordered
        patient_rule = RequestAlgorithm::PatientRule.new(patient: @patient)

        render :new, locals: {
          frequencies: frequencies, labs: labs, patient_rule: patient_rule
        }
      end

      def create
        @patient_rule = RequestAlgorithm::PatientRule.new(patient_rule_params)

        if @patient_rule.save
          redirect_to patient_pathology_required_observations_path(@patient),
            notice: t(".success", model_name: "patient_rule")
        else
          flash[:error] = t(".failed", model_name: "patient_rule")
          render :new
        end
      end

      private

      def patient_rule_params
        params.require(:pathology_request_algorithm_patient_rule)
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
