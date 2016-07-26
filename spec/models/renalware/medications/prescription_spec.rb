require "rails_helper"

module Renalware
  module Medications
    RSpec.describe Prescription, type: :model do
      describe "validations" do
        it { should validate_presence_of :patient }
        it { should validate_presence_of :treatable }
        it { should validate_presence_of(:drug) }
        it { should validate_presence_of(:dose_amount) }
        it { should validate_presence_of(:dose_unit) }
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

      describe "scopes" do
        before do
          create(:prescription,
            notes: ":expires_today:",
            termination: build(:prescription_termination, terminated_on: "2010-01-02")
          )
          create(:prescription,
            notes: ":expired_yesteday:",
            termination: build(:prescription_termination, terminated_on: "2010-01-01")
          )
          create(:prescription, notes: ":not_specified:")
          create(:prescription,
             notes: ":expires_tomorrow:",
             termination: build(:prescription_termination, terminated_on: "2010-01-03")
          )
        end

        describe ".current" do
          subject(:prescriptions) { Prescription.current("2010-01-02") }

          it "returns prescriptions that terminate today or later, or not specified" do
            expect(prescriptions.map(&:notes)).to \
              include(":expires_tomorrow:", ":not_specified:")
            expect(prescriptions.map(&:notes)).not_to \
              include(":expires_today:", ":expires_yesterday:")
          end
        end

        describe ".terminated" do
          subject(:prescriptions) { Prescription.terminated("2010-01-02") }

          it "returns prescriptions that terminate today or later, or not specified" do
            expect(prescriptions.map(&:notes)).to \
              include(":expires_today:", ":expired_yesteday:")
            expect(prescriptions.map(&:notes)).not_to \
              include(":expires_tomorrow:", ":not_specified:")
          end
        end
      end

      describe "state predicates" do
        let(:date_today) { Date.parse("2010-01-02")}

        describe "#current?" do
          context "given the termination date is today" do
            let(:prescription) do
              build(:prescription,
                termination: build(:prescription_termination, terminated_on: "2010-01-02"))
            end

            it { expect(prescription.current?(date_today)).to be_truthy }
          end

          context "given the termination date is after today" do
            let(:prescription) do
              build(:prescription,
                termination: build(:prescription_termination, terminated_on: "2010-01-03"))
            end

            it { expect(prescription.current?(date_today)).to be_truthy }
          end

          context "given the termination date is before today" do
            let(:prescription) do
              build(:prescription,
                termination: build(:prescription_termination, terminated_on: "2010-01-01"))
            end

            it { expect(prescription.current?(date_today)).to be_falsey }
          end
        end

        describe "#terminated?" do
          context "given the termination date is specified" do
            let(:prescription) { build(:prescription, termination: build(:prescription_termination, terminated_on: "2010-01-02")) }
            it { expect(prescription.terminated?).to be_truthy }
          end

          context "given the termination date is not specified" do
            let(:prescription) { build(:prescription) }
            it { expect(prescription.terminated?).to be_falsey }
          end
        end
      end

      describe "entity services" do
        describe "#terminate" do
          context "given an active prescription" do
            subject(:active_prescription) { build(:prescription) }

            let(:user) { build(:user) }
            let(:terminated_on) { Date.parse("2010-10-10") }

            it "records the termination" do
              termination = active_prescription.terminate(by: user, terminated_on: terminated_on)

              expect(termination.terminated_on).to eq(terminated_on)
              expect(termination).to be_valid
            end
          end
        end
      end
    end
  end
end
