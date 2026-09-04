module Renalware
  describe MDMPresenter do
    describe "#clinic_visits" do
      it "presents visits that already expose their Heidi state" do
        visit = create(:clinic_visit)
        create(:heidi_session, clinic_visit: visit, patient: visit.patient, status: :synced)

        presenter = described_class.new(patient: visit.patient, view_context: double)
        presented_visit = presenter.clinic_visits.first

        expect(presented_visit.heidi_status).to eq("synced")
      end

      it "eager loads heidi_sessions so rendering the table does not trigger an N+1" do
        visit = create(:clinic_visit)
        create(:heidi_session, clinic_visit: visit, patient: visit.patient, status: :synced)

        presenter = described_class.new(patient: visit.patient, view_context: double)
        presented_visit = presenter.clinic_visits.first

        expect(presented_visit.association(:heidi_sessions)).to be_loaded
      end
    end
  end
end
