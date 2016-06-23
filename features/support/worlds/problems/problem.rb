module World
  module Problems::Problem
    module Domain
      # @section helpers
      #
      def problem_for(patient)
        patient.problems.last!
      end

      def seed_problem_for(patient, user)
        patient.problems.create(
          description: "outcome",
          notes: [
            Renalware::Problems::Note.new(description: "note", by: user)
          ]
        )
      end

      # @section commands
      #
      def record_problem_for(patient:, user: nil)
        seed_problem_for(patient, user)
      end

      def revise_problem_for(patient:, user:, description:)
        problem = patient.problems.last!

        problem.update!(description: description)
      end

      def problem_drug_selector
        nil
      end

      # @section expectations
      #
      def expect_problem_to_be_recorded(patient:)
        problem = patient.problems.last

        expect(problem).to be_present
      end

      def expect_problem_revisions_to_be_recorded(patient:)
        problem = patient.problems.last!

        expect(problem.created_at).not_to eq(problem.updated_at)
      end
    end

    module Web
      include Domain

      # @section commands
      #
      def record_problem_for(patient:, user:)
        login_as user

        visit patient_problems_path(patient)
        click_on "Add problem"
        fill_in "Description", with: "major problem"
        click_on "Save"
      end

      def revise_problem_for(patient:, user:, description:)
        login_as user

        visit patient_problem_path(patient, problem_for(patient))
        within_fieldset "Problem" do
          click_on "Edit"
        end

        within_fieldset "Edit problem" do
          fill_in "Description", with: description
          click_on "Save"
        end
      end
    end
  end
end
