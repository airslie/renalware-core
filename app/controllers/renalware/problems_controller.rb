module Renalware
  class ProblemsController < BaseController
    before_action :load_patient, only: [:index, :update]

    def index
      @patient.problems.build
    end

    def update
      authorize @patient

      if @patient.update(problem_params)
        redirect_to patient_problems_path(@patient), notice: "Problems successfully updated."
      else
        render :index
      end
    end

    private

    def problem_params
      params.require(:patient).permit(
        problems_attributes:  [:id, :snomed_id, :snomed_description, :description, :_destroy]
      )
    end
  end
end
