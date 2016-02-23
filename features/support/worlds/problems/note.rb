module World
  module Problems::Note
    module Domain
      # @section helpers
      #
      def problem_note_for(patient)
        patient.problems.last!
      end

      # @section commands
      #
      def record_problem_note_for(problem:, user:)
        problem.notes.create(
          description: "outcome",
          by: user
        )
      end

      def problem_drug_selector
        nil
      end

      # @section expectations
      #
      def expect_problem_note_to_be_recorded(problem:)
        note = problem.notes.last

        expect(note).to be_present
      end
    end

    module Web
      include Domain

      # @section commands
      #
      def record_problem_note_for(problem:, user:)
        login_as user

        visit patient_problem_path(problem.patient, problem)
        within_fieldset "Notes" do
          find("a", text: "Add a note").trigger("click")
          wait_for_ajax

          fill_in "Text", with: "this is something"
          choose "Yes"
          click_on "Save"
          wait_for_ajax
        end
      end
    end
  end
end
