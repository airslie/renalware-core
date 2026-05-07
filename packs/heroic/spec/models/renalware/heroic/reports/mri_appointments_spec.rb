# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  # Test class so we can treat the report view like a regular AR table
  class TestMriAppointments < ApplicationRecord
    self.table_name = "renalware_heroic.report_mri_appointments"
    def readonly?
      true
    end
  end

  RSpec.describe TestMriAppointments do
    let(:user) { create(:user) }
    let(:participant) { create(:heroic_participation, by: user) }
    let(:patient) { Renalware::Clinics.cast_patient(participant.patient) }

    def reset_mri_data(participant)
      doc = participant.document
      doc.mri_antaros_0.booked_for = nil
      doc.mri_antaros_0.completed = nil
      doc.mri_antaros_2.booked_for = nil
      doc.mri_antaros_2.completed = nil
      doc.mri_antaros_5.booked_for = nil
      doc.mri_antaros_5.completed = nil
      participant.save!
    end

    context "when participant is inactive" do
      before do
        participant.document.withdrawal.status = "4_inactive"
        participant.save!
      end

      context "when they have a 'next' appointment" do
        before do
          reset_mri_data(participant)
          doc = participant.document
          doc.mri_antaros_0.booked_for = Time.zone.now
          doc.mri_antaros_0.completed = nil
          participant.save!
        end

        it "does not return the patient row" do
          expect(described_class.count).to eq(0)
        end
      end

      context "when they have a 'missed' appointment" do
        before do
          reset_mri_data(participant)
          doc = participant.document
          doc.mri_antaros_0.booked_for = Time.zone.now - 1.month
          doc.mri_antaros_0.completed = nil
          participant.save!
        end

        it "does not return the patient row" do
          expect(described_class.count).to eq(0)
        end
      end
    end

    context "when participant is active" do
      before do
        participant.document.withdrawal.status = "1_active"
        participant.save!
      end

      context "when patient has no MRI scans booked ie booked_for is not present" do
        before do
          reset_mri_data(participant)
        end

        it "returns no rows for the patient" do
          expect(described_class.count).to eq(0)
        end
      end

      context "when patient a missed scan - booked_for is in the past and completed is null" do
        before do
          reset_mri_data(participant)
          doc = participant.document
          doc.mri_antaros_0.booked_for = Time.zone.now - 1.week
          doc.mri_antaros_0.completed = nil
          participant.save!
        end

        it "returns a row for the missed scan" do
          results = described_class.all

          expect(results.size).to eq(1)
          result = results[0]
          expect(result["Status"]).to eq("1_active")
          expect(result["Date of missed or next due scan"].to_date)
            .to eq((Time.zone.now - 1.week).to_date)
          expect(result["MRI scan number"]).to eq(0)
        end

        context "when patient a due a scan - booked_for is the future and completed is null" do
          before do
            reset_mri_data(participant)
            doc = participant.document
            doc.mri_antaros_2.booked_for = Time.zone.now + 1.week
            doc.mri_antaros_2.completed = nil
            participant.save!
          end

          it "returns a row for the missed scan" do
            results = described_class.all

            expect(results.size).to eq(1)
            result = results[0]
            expect(result["Date of missed or next due scan"].to_date)
              .to eq((Time.zone.now + 1.week).to_date)
            expect(result["MRI scan number"]).to eq(2)
          end
        end

        context "when past scan was complete = yes" do
          before do
            reset_mri_data(participant)
            doc = participant.document
            doc.mri_antaros_2.booked_for = Time.zone.now - 1.week
            doc.mri_antaros_2.completed = :yes
            participant.save!
          end

          it "does not return the row" do
            results = described_class.all

            expect(results.size).to eq(0)
          end
        end

        context "when past scan was complete = no (for some reason)" do
          before do
            reset_mri_data(participant)
            doc = participant.document
            doc.mri_antaros_2.booked_for = Time.zone.now - 1.week
            doc.mri_antaros_2.completed = :no
            participant.save!
          end

          it "does not return the row" do
            results = described_class.all

            expect(results.size).to eq(0)
          end
        end
      end
    end
  end
end
