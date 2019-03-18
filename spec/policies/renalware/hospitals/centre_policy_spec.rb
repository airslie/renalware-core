# frozen_string_literal: true

require "rails_helper"

module Renalware::Hospitals
  describe CentrePolicy::Scope do
    subject(:query) { described_class.new(user, Centre) }

    let(:hospital_centre_a) { create(:hospital_centre, code: "A", name: "A", host_site: true) }
    let(:hospital_centre_b) { create(:hospital_centre, code: "B", name: "B", host_site: false) }
    let(:hospital_centre_c) { create(:hospital_centre, code: "C", name: "C", host_site: false) }

    describe "#resolve which returns an array of hospital centres a user can add a patient to" do
      subject(:results) { query.resolve }

      before do
        hospital_centre_a
        hospital_centre_b
        hospital_centre_c
      end

      context "when user is a super_admin" do
        let(:user) { create(:user, :super_admin, hospital_centre: hospital_centre_a) }

        it { is_expected.to eq([hospital_centre_a, hospital_centre_b, hospital_centre_c]) }
      end

      context "when user is not a super_admin" do
        let(:user) { create(:user, :clinical, hospital_centre: hospital_centre_a) }

        it "returns the user's site i.e. the user can only add a patient to their own site" do
          expect(results).to eq([hospital_centre_a])
        end
      end

      context "when user is not a super_admin and has no hospital_centre_id" do
        let(:user) { create(:user, :clinical, hospital_centre: nil) }

        it { is_expected.to be_empty }
      end
    end
  end
end
