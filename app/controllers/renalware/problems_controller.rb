module Renalware
  class ProblemsController < BaseController
    before_action :load_patient, only: [:index, :update]

    def index
      @patient.problems.build
    end

    def update
      reject_invalid_or_update_problems(problem_params)
      redirect_to patient_problems_path(@patient), notice: "Problems successfully updated."
    end

    private

    def reject_invalid_or_update_problems(problem_params)
      @patient.update(problem_params)
    end

    def problem_params
      params.require(:patient).permit(
        problems_attributes:  [:id, :description, :_destroy]
      )
    end
  end
end
