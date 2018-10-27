# frozen_string_literal: true

module Renalware
  module Problems
    class ProblemsController < BaseController
      def index
        problems = patient.problems
        authorize problems
        render locals: {
          patient: patient,
          current_problems: problems.current.with_updated_by.ordered,
          archived_problems: problems.archived.with_created_by.ordered
        }
      end

      def show
        problem = patient.problems.with_archived.includes(versions: :item).find(params[:id])
        notes = problem.notes.with_updated_by.ordered
        authorize problem
        render locals: {
          patient: patient,
          problem: problem,
          notes: notes
        }
      end

      def edit
        problem = find_problem
        authorize problem
        render locals: {
          patient: patient,
          problem: problem
        }
      end

      def update
        authorize(problem = find_problem)

        if update_problem(problem)
          redirect_to patient_problem_path(patient, problem), notice: success_msg_for("problem")
        else
          flash.now[:error] = failed_msg_for("problem")
          render :edit, locals: {
            patient: patient,
            problem: problem
          }
        end
      end

      def new
        problem = patient.problems.build
        authorize problem
        render locals: { patient: patient, problem: problem }
      end

      def create
        problem = patient.problems.new(problem_params)
        authorize problem

        if problem.save
          redirect_to patient_problems_url(patient), notice: success_msg_for("problem")
        else
          flash.now[:error] = failed_msg_for("problem")
          render :new, locals: { patient: patient, problem: problem }
        end
      end

      def destroy
        problem = find_problem
        authorize problem
        problem.by = current_user
        problem.save!
        problem.destroy
        redirect_to patient_problems_path(patient), notice: success_msg_for("problem")
      end

      def sort
        authorize Problem, :sort?
        ids = params[:problems_problem]
        Problem.sort(ids)
        render json: ids
      end

      private

      def find_problem
        patient.problems.find(params[:id])
      end

      def update_problem(problem)
        problem.assign_attributes(problem_params)
        problem.save
      end

      def problem_params
        params.require(:problems_problem)
              .permit(:description)
              .merge(by: current_user)
      end
    end
  end
end
