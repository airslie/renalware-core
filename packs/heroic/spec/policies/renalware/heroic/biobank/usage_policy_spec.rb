# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  describe BioBank::UsagePolicy, type: :policy do
    include HeroicHelpers

    subject(:policy) { described_class }

    let(:user) { create(:user) }
    let(:study) { create(:heroic_research_study) }
    let(:patient) { create(:patient) }
    let(:sample) { create(:bio_bank_sample, :serum, patient: patient, by: user) }
    let(:aliquot) { create(:bio_bank_aliquot, sample: sample, by: user) }

    context "when the usage was created less than 24 hours ago" do
      let(:usage) { create(:bio_bank_usage, usable: aliquot, by: user) }

      permissions :edit? do
        it "permits a super admin" do
          user = create(:user, :super_admin)
          expect(policy).to permit(user, usage)
        end

        it "permits a study manager" do
          user = create(:user, :clinical)
          make_user_an_investigator(user: user, manager: true)
          expect(policy).to permit(user, usage)
        end

        it "permits a non-manager investigator with e.g. a clinical role" do
          user = create(:user, :clinical)
          make_user_an_investigator(user: user, manager: false)
          expect(policy).to permit(user, usage)
        end
      end
    end

    context "when the aliquot was created more than 24 hours ago" do
      let(:usage) { create(:bio_bank_aliquot, sample: sample, by: user, created_at: 2.days.ago) }

      permissions :edit? do
        it "permits a super admin" do
          user = create(:user, :super_admin)
          expect(policy).to permit(user, usage)
        end

        it "permits a study manager" do
          user = create(:user, :clinical)
          make_user_an_investigator(user: user, manager: true)
          expect(policy).to permit(user, usage)
        end

        it "does not permit a non-manager investigator with a clinical role" do
          user = create(:user, :clinical)
          make_user_an_investigator(user: user, manager: false)
          expect(policy).not_to permit(user, usage)
        end
      end
    end

    permissions :create? do
      let(:usage) { create(:bio_bank_aliquot, sample: sample, by: user, created_at: 2.days.ago) }

      it "permits a super admin" do
        user = create(:user, :super_admin)
        expect(policy).to permit(user, usage)
      end

      it "permits a study manager" do
        user = create(:user, :clinical)
        make_user_an_investigator(user: user, manager: true)
        expect(policy).to permit(user, usage)
      end

      it "permits a non-manager investigator with a clinical role" do
        user = create(:user, :clinical)
        make_user_an_investigator(user: user, manager: false)
        expect(policy).to permit(user, usage)
      end

      it "doesn't permit anyone else" do
        study
        user = create(:user, :clinical)
        expect(policy).not_to permit(user, usage)
      end
    end
  end
end
