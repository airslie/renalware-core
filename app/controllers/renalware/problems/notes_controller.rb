module Renalware
  module Problems
    class NotesController < BaseController
      before_action :load_patient

      def index
        @problem = @patient.problems.find(params[:problem_id])
        @notes = @problem.notes.ordered
      end

      def new
        @problem = @patient.problems.find(params[:problem_id])
        @note = @problem.notes.new

        authorize @patient
      end

      def create
        @problem = @patient.problems.find(params[:problem_id])

        authorize @patient

        @note = @problem.notes.create(notes_params)
      end

      private

      def notes_params
        params.require(:problems_note).permit(:description, :show_in_letter).merge(by: current_user)
      end
    end
  end
end
