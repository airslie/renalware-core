module Renalware
  module HD
    describe DashboardPresenter do
      subject(:presenter) { described_class.new(patient, nil, user) }

      let(:patient) { create(:hd_patient) }

      context "when the user has write privileges" do
        let(:user) { create(:user, :clinical) }

        it "allows adding an HD session when the patient has never had the HD modality" do
          expect(patient).not_to have_ever_been_on_hd

          expect(presenter).to be_can_add_session
        end

        it "allows adding an HD DNA session when the patient has never had the HD modality" do
          expect(patient).not_to have_ever_been_on_hd

          expect(presenter).to be_can_add_dna_session
        end
      end

      context "when the user does not have write privileges" do
        let(:user) { create(:user, :read_only) }

        it "does not allow adding an HD session" do
          expect(presenter).not_to be_can_add_session
        end

        it "does not allow adding an HD DNA session" do
          expect(presenter).not_to be_can_add_dna_session
        end
      end
    end
  end
end
