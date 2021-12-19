# frozen_string_literal: true

module Renalware
  module Problems
    class ProblemsController < BaseController
      skip_before_action :track_ahoy_visit, only: :search

      def index
        problems = patient.problems.with_notes
        authorize problems
        render locals: {
          patient: patient,
          problem: patient.problems.build,
          current_problems: problems.current.with_updated_by.ordered,
          archived_problems: problems.archived.with_created_by.ordered
        }
      end

      def search
        authorize Problem, :search?

        nhs_client.query(params[:term], count: 10, offset: 10 * params[:page].to_i)
        problems = nhs_client.problems.each do |p|
          p[:id] = p["display"]
          p[:text] = p["display"]
        end
        problems_total = nhs_client.problems_total

        render json: { problems: problems, problems_total: problems_total }
      end

      def show
        problem = patient.problems.with_archived.with_versions.find(params[:id])
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

      def create
        problem = patient.problems.new(problem_params)
        authorize problem

        if problem.save
          render partial: "current_problem", locals: { problem: problem }, status: :created
        else
          render json: problem.errors.full_messages, status: :not_acceptable
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
              .permit(:description, :snomed_id)
              .merge(by: current_user)
      end
    end
  end
end
