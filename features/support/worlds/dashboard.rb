module World
  module Dashboard
    module Domain
      def expect_draft_letter_accessible_from_dashboard(user:, patient:)
        letter_patient = Renalware::Letters.cast_patient(patient)
        dashboard = Renalware::Dashboard::DashboardPresenter.new(user)

        expect(dashboard.draft_letters.first).to eq(letter_patient.letters.draft.first)
      end

      def expect_pending_letter_accessible_from_dashboard(user:, patient:)
        letter_patient = Renalware::Letters.cast_patient(patient)
        dashboard = Renalware::Dashboard::DashboardPresenter.new(user)

        expect(dashboard.letters_pending_review.first).to eq(letter_patient.letters.pending_review.first)
      end
    end
  end
end
