module Renalware
  module Problems
    class ProblemsController < BaseController
      before_action :load_patient

      def index
        render :index, locals: locals(Problem.new)
      end

      def show
        @problem = patient.problems.with_archived.find(params[:id])
        @notes = @problem.notes.with_updated_by.ordered
      end

      def edit
        @problem = patient.problems.find(params[:id])
      end

      def update
        @problem = @patient.problems.find(params[:id])
        @problem.assign_attributes(problem_params)

        if @problem.save
          redirect_to patient_problems_path(@patient),
            notice: t(".success", model_name: "problem")
        else
          flash[:error] = t(".failed", model_name: "problem")
          render :edit, locals: locals(@problem)
        end
      end

      def create
        @problems = patient.problems
        @problem = patient.problems.new(problem_params)

        if @problem.save
          redirect_to patient_problems_url(patient),
            notice: t(".success", model_name: "problem")
        else
          flash[:error] = t(".failed", model_name: "problem")
          render :index, locals: locals(@problem)
        end
      end

      def destroy
        @problem = patient.problems.find(params[:id])
        @problem.by = current_user
        @problem.save!
        @problem.destroy

        redirect_to patient_problems_path(patient),
          notice: t(".success", model_name: "problem")
      end

      def sort
        ids = params[:problems_problem]
        Problem.sort(ids)
        render json: ids
      end

      private

      def locals(problem)
        {
          problem: problem,
          current_problems: patient.problems.current.with_created_by.ordered,
          archived_problems: patient.problems.archived.with_created_by.ordered
        }
      end
      def problem_params
        params.require(:problems_problem)
              .permit(:description)
              .merge(by: current_user)
      end
    end
  end
end
