# frozen_string_literal: true

require "rails_helper"

RSpec.describe "BioBank samples" do
  let(:user) { @current_user }
  let(:patient) { create(:patient, by: user) }

  describe "PATCH update" do
    context "when the sample cannot be updated" do
      it "re-renders the edit form" do
        sample = create(:bio_bank_sample, :dna, patient: patient, by: user)
        allow(Renalware::Heroic::BioBank::Sample)
          .to receive(:find_by!)
          .with(patient: patient, id: sample.id.to_s)
          .and_return(sample)
        allow(sample).to receive(:update_by).and_return(false)

        patch heroic.bio_bank_patient_sample_path(patient, sample), params: {
          sample: {
            notes: "New notes"
          }
        }

        expect(response).to be_successful
      end
    end
  end
end
