require 'rails_helper'

module Renalware
  RSpec.describe Medication, :type => :model do
    context "validations" do
      it { should validate_presence_of :patient }
      it { should validate_presence_of :treatable }
      it { should validate_presence_of(:drug) }
      it { should validate_presence_of(:dose) }
      it { should validate_presence_of(:medication_route) }
      it { should validate_presence_of(:frequency) }
      it { should validate_presence_of(:prescribed_on) }
      it { should validate_presence_of(:provider) }

      describe "#valid?" do
        context "route description" do
          context "given a route" do
            before { subject.medication_route = build(:medication_route) }

            it { is_expected.not_to validate_presence_of(:route_description) }
          end

          context "given a `other` route" do
            before { subject.medication_route = build(:medication_route, :other) }

            it { is_expected.to validate_presence_of(:route_description) }
          end

          context "given a route and a route description" do
            before do
              subject.medication_route = build(:medication_route)
              subject.route_description = "::route description::"
            end

            it "adds an error" do
              subject.valid?

              expect(subject.errors[:route_description]).to be_present
            end
          end
        end
      end
    end

    context "scopes" do
      describe ".current" do
        it "returns medications that terminate today or later, or not specified" do
          create(:medication, notes: ":expires_today:", terminated_on: "2010-01-02")
          create(:medication, notes: ":expired_yesteday:", terminated_on: "2010-01-01")
          create(:medication, notes: ":not_specified:")
          create(:medication, notes: ":expires_tomorrow:", terminated_on: "2010-01-03")

          medications = Medication.current("2010-01-02")

          expect(medications.map(&:notes)).to \
            include(":expires_today:", ":expires_tomorrow:", ":not_specified:")
          expect(medications.map(&:notes)).not_to include(":expires_yesterday:")
        end
      end
    end
  end
end
