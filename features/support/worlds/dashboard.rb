module World
  module Dashboard
    module Domain
      def expect_draft_letter_accessible_from_dashboard(user:, patient:)
        letter_patient = Renalware::Letters.cast_patient(patient)
        dashboard = Renalware::Dashboard::DashboardPresenter.new(user)

        expect(dashboard.draft_letters.first).to eq(letter_patient.letters.draft.first)
      end
    end
  end
end
