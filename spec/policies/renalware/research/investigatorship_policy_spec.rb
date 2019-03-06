# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Research::InvestigatorshipPolicy, type: :policy do
    subject(:policy) { described_class }

    let(:study) { create(:research_study) }
    let(:investigatorship) { build_stubbed(:research_investigatorship, study: study) }

    def make_user_an_investigator(user:, manager: false)
      create(
        :research_investigatorship,
        user: user,
        study: investigatorship.study,
        manager: manager
      )
    end

    permissions :destroy? do
      it "permits a super admin" do
        user = create(:user, :super_admin)
        expect(policy).to permit(user, investigatorship)
      end

      it "permits a study manager" do
        user = create(:user, :clinical)
        make_user_an_investigator(user: user, manager: true)
        expect(policy).to permit(user, investigatorship)
      end

      it "does not permit a non-manager investigator with a clinical role" do
        user = create(:user, :clinical)
        make_user_an_investigator(user: user, manager: false)
        expect(policy).not_to permit(user, investigatorship)
      end
    end

    %i(edit? update? create? new?).each do |permission|
      permissions permission do
        it "permits a super admin" do
          user = create(:user, :super_admin)
          expect(policy).to permit(user, investigatorship)
        end

        it "permits a study manager" do
          user = create(:user, :clinical)
          make_user_an_investigator(user: user, manager: true)
          expect(policy).to permit(user, investigatorship)
        end

        it "does not permit a non manager investigator" do
          user = create(:user, :clinical)
          make_user_an_investigator(user: user, manager: false)
          expect(policy).not_to permit(user, investigatorship)
        end

        it "does not anyone else" do
          user = create(:user, :clinical)
          expect(policy).not_to permit(user, investigatorship)
        end
      end
    end
  end
end
