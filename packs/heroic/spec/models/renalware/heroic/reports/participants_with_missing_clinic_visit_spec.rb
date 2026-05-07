# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  # Test class so we can treat the report view like a regular AR table
  class TestParticipantsWithMissingClinicVisit < ApplicationRecord
    self.table_name = "report_participants_with_missing_clinic_visits"
    def readonly?
      true
    end
  end

  RSpec.describe TestParticipantsWithMissingClinicVisit do
    let(:user) { create(:user) }
    let(:clinic) { create(:heroic_clinic, user_id: user.id) }
    let(:serum_sample_type) { create(:serum_sample_type) }
    let(:participant) { create(:heroic_participation, by: user) }
    let(:patient) { Renalware::Clinics.cast_patient(participant.patient) }

    def create_visit_on(date)
      create(
        :heroic_clinic_visit,
        clinic: clinic,
        patient: patient,
        date: date,
        by: user
      )
    end

    def create_sample_on(date)
      create(
        :bio_bank_sample,
        :serum,
        patient: participant.patient,
        collected_at: date,
        by: user
      )
    end

    context "when there is one or more visit within 15 days of the sample collected dates" do
      it "does not return a row" do
        create_sample_on(1.month.ago)
        create_visit_on((1.month + 14.days).ago)
        create_visit_on((1.month - 14.days).ago)

        expect(described_class.all.size).to eq(0)
      end
    end

    context "when there is no visit within 15 days" do
      it "returns a row" do
        sample = create_sample_on 1.month.ago
        create_visit_on 1.year.ago

        results = described_class.all

        expect(results.size).to eq(1)
        row = results.first
        expect(row).to have_attributes(
          "Patient HEROIC study number" => nil,
          "Surname" => "Jones",
          "First Name" => "Jack",
          "Serum date" => sample.collected_at.to_date
        )
      end
    end
  end
end
