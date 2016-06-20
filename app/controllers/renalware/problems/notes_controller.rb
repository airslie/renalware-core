module Renalware
  module Problems
    class NotesController < BaseController
      before_action :load_patient
      before_action :load_bookmark

      def index
        load_problem
        render_index
      end

      def new
        load_problem
        note = @problem.notes.new
        render_form(note, url: patient_problem_notes_path(@patient, @problem))
      end

      def create
        load_problem
        note = @problem.notes.create(notes_params)

        if note.save
          render_index
        else
          render_form(note, url: patient_problem_notes_path(@patient, @problem))
        end
      end

      private

      def load_problem
        @problem = @patient.problems.find(params[:problem_id])
      end

      def render_index
        render "index", locals: { problem: @problem, notes: notes }
      end

      def render_form(note, url:)
        render "form", locals: { problem: @problem, note: note, url: url }
      end

      def notes_params
        params.require(:problems_note).permit(:description).merge(by: current_user)
      end

      def notes
        @notes ||= @problem.notes.ordered
      end
    end
  end
end
