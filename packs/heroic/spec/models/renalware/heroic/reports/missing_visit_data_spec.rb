# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  # Test class so we can treat the report view like a regular AR table
  class TestIncompleteClinicVisits < ApplicationRecord
    self.table_name = "renalware_heroic.report_incomplete_clinic_visits"
    def readonly?
      true
    end
  end

  RSpec.describe TestIncompleteClinicVisits do
    let(:user) { create(:user) }
    let(:clinic) { create(:heroic_clinic, user_id: user.id) }
    let(:participant) { create(:heroic_participation, by: user) }
    let(:patient) { Renalware::Clinics.cast_patient(participant.patient) }

    # rubocop:disable-next Metrics/MethodLength
    def create_visit(
      health_status_mobility: "1_none",
      alcohol_history: "1_never",
      smoking_history: "1_never"
    )
      create(
        :heroic_clinic_visit,
        clinic: clinic,
        patient: patient,
        date: Time.zone.now,
        by: user
      ).tap do |visit|
        visit.document.health_status.mobility = health_status_mobility
        visit.document.alcohol.history = alcohol_history
        visit.document.smoking.history = smoking_history
        visit.document.visit_number = 1
        visit.save!
      end
    end

    context "when a visit complete data" do
      it "does not return that visit" do
        create_visit

        results = described_class.all

        expect(results.size).to eq(0)
      end
    end

    context "when a visit has missing health_status mobility" do
      it "returns that visit" do
        visit = create_visit(health_status_mobility: nil)

        results = described_class.all

        expect(results.size).to eq(1)
        row = results.first
        expect(row).to have_attributes(
          "Patient HEROIC study number" => nil,
          "Surname" => "Jones",
          "First Name" => "Jack",
          "Status" => nil,
          "HEROIC clinic visit number" => 1,
          "Date of HEROIC clinic visit" => visit.date,
          "health_status_mobility" => "null",
          "alcohol_history" => "",
          "smoking_history" => ""
        )
      end
    end

    context "when a visit has missing smoking history" do
      it "returns that visit" do
        create_visit(smoking_history: nil)

        results = described_class.all

        expect(results.size).to eq(1)
      end

      context "when a visit has missing alcohol history" do
        it "returns that visit" do
          create_visit(alcohol_history: nil)

          results = described_class.all

          expect(results.size).to eq(1)
        end
      end
    end
  end
end
