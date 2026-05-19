# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Delete an aliquot from a sample" do
  include HeroicHelpers

  let(:study) { create(:heroic_research_study) }

  context "when aliquot was created within a configured window" do
    context "when the use is just an investigator (not a superadmin or study manager)" do
      it "allow deleting the aliquot" do
        user = login_as_clinical
        make_user_an_investigator(user: user)

        serum = create(:bio_bank_sample, :serum, by: user)
        create(:bio_bank_aliquot, sample: serum, by: user)
        expect(serum.aliquots.count).to eq(1)

        visit heroic.bio_bank_sample_aliquots_path(serum)

        within ".bio-bank-aliquots tbody" do
          click_on "Delete"
        end

        expect(serum.reload.aliquots.count).to eq(0)
      end
    end
  end
end
