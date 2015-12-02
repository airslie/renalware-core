module Renalware
  module Problems
    class ProblemsController < BaseController
      before_action :load_patient

      def index
        @problem = Problem.new
        @problems = @patient.problems
      end

      def edit
        @problem = @patient.problems.find(params[:id])
        render
      end

      def update
        @problem = @patient.problems.find(params[:id])

        if @problem.update(problem_params)
          redirect_to patient_problems_path(@patient), notice: "Problem successfully updated."
        else
          flash[:error] = "Please provide a description."
          render :edit
        end
      end

      def create
        @problems = @patient.problems
        @problem = @patient.problems.new(problem_params)

        if @problem.save
          redirect_to patient_problems_url(@patient), notice: "Problem successfully created."
        else
          flash[:error] = "Please provide a description."
          render :index
        end
      end

      def destroy
        @problem = @patient.problems.find(params[:id])
        @problem.destroy

        redirect_to patient_problems_path(@patient),
          notice: "The problem was successfully terminated."
      end

      private

      def problem_params
        params.require(:problems_problem).permit(:description)
      end
    end
  end
end
