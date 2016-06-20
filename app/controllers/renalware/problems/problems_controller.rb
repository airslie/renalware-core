module Renalware
  module Problems
    class ProblemsController < BaseController
      before_action :load_patient
      before_action :load_bookmark

      def index
        @problem = Problem.new
        @problems = @patient.problems.ordered
      end

      def show
        @problem = @patient.problems.find(params[:id])
        @notes = @problem.notes.ordered
      end

      def edit
        @problem = @patient.problems.find(params[:id])
      end

      def update
        @problem = @patient.problems.find(params[:id])

        if @problem.update(problem_params)
          redirect_to patient_problems_path(@patient),
            notice: t(".success", model_name: "problem")
        else
          flash[:error] = t(".failed", model_name: "problem")
          render :edit
        end
      end

      def create
        @problems = @patient.problems
        @problem = @patient.problems.new(problem_params)

        if @problem.save
          redirect_to patient_problems_url(@patient),
            notice: t(".success", model_name: "problem")
        else
          flash[:error] = t(".failed", model_name: "problem")
          render :index
        end
      end

      def destroy
        @problem = @patient.problems.find(params[:id])
        @problem.destroy

        redirect_to patient_problems_path(@patient),
          notice: t(".success", model_name: "problem")
      end

      def sort
        ids = params[:problems_problem]
        Problem.sort(ids)
        render json: ids
      end

      private

      def problem_params
        params.require(:problems_problem).permit(:description)
      end
    end
  end
end
