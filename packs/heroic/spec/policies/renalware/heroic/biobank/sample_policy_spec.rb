# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  describe BioBank::SamplePolicy, type: :policy do
    include HeroicHelpers

    subject(:policy) { described_class }

    let(:user) { create(:user) }
    let(:study) { create(:heroic_research_study) }
    let(:patient) { create(:patient) }
    let(:sample) { create(:bio_bank_sample, :serum, patient: patient, by: user) }

    permissions :destroy? do
      it "permits a super admin" do
        user = create(:user, :super_admin)

        expect(policy).to permit(user, sample)
      end

      it "permits a study manager" do
        user = create(:user, :clinical)
        make_user_an_investigator(user: user, manager: true)

        expect(policy).to permit(user, sample)
      end

      it "does not permits a non-manager investigator with e.g. a clinical role" do
        user = create(:user, :clinical)
        make_user_an_investigator(user: user, manager: false)

        expect(policy).not_to permit(user, sample)
      end

      it "doesn't permit anyone else" do
        study
        user = create(:user, :clinical)

        expect(policy).not_to permit(user, sample)
      end
    end

    %i(edit? new?).each do |permission|
      permissions permission do
        it "permits a super admin" do
          user = create(:user, :super_admin)

          expect(policy).to permit(user, sample)
        end

        it "permits a study manager" do
          user = create(:user, :clinical)
          make_user_an_investigator(user: user, manager: true)

          expect(policy).to permit(user, sample)
        end

        it "permits a non-manager investigator with e.g. a clinical role" do
          user = create(:user, :clinical)
          make_user_an_investigator(user: user, manager: false)

          expect(policy).to permit(user, sample)
        end

        it "doesn't permit anyone else" do
          study
          user = create(:user, :clinical)

          expect(policy).not_to permit(user, sample)
        end
      end
    end
  end
end
