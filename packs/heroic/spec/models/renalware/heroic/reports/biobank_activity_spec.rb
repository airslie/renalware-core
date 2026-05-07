# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  # Test class so we can treat the report view like a regular AR table
  class TestBioBankActivityReportView < ApplicationRecord
    self.table_name = "renalware_heroic.report_biobank_activity"

    def readonly?
      true
    end
  end

  RSpec.describe TestBioBankActivityReportView do
    let(:user) { create(:user) }
    let(:patient) { create(:patient, family_name: "Smith", given_name: "John") }
    let(:participant) { create(:heroic_participation, patient: patient, by: user) }

    def create_sample(type, date: Time.zone.now, with_aliquots: 1)
      create(
        :bio_bank_sample,
        type,
        patient: participant.patient,
        collected_at: date,
        by: user
      ).tap do |sample|
        with_aliquots.times do
          create(:bio_bank_aliquot, sample: sample, by: user)
        end
      end
    end
    it "returns the expected data" do
      serum_date = Time.zone.parse("2019-01-01 12:00:00")
      serum = create_sample(:serum, date: serum_date, with_aliquots: 1)
      # create 2 plasma samples, one 4 days in the future with 0 aliquots
      # and one 3 days in the past with 2 aliquots - the latter should be chosen
      # as it is 'closest' to serum_date
      create_sample(:epla, date: serum_date + 3.days, with_aliquots: 0)
      create_sample(:epla, date: serum_date - 2.days, with_aliquots: 2)

      # create 2 dna samples outside the 15 day zone around serum_date, so neither will be matched
      create_sample(:dna, date: serum_date + 16.days, with_aliquots: 1)
      create_sample(:dna, date: serum_date - 16.days, with_aliquots: 1)

      # RNA has 5 aliquots but 2 are used so the results should say 3 (remaining)
      rna_sample = create_sample(:rna, date: serum_date, with_aliquots: 5)
      create(:bio_bank_usage, usable: rna_sample.aliquots[0], by: user)
      create(:bio_bank_usage, usable: rna_sample.aliquots[1], by: user)

      create_sample(:urine, date: serum_date, with_aliquots: 1)

      # No Urine-IN sample so aliqut count should be 0 in results

      results = described_class.all

      expect(results.size).to eq(1)

      expect(results.first).to have_attributes(
        "Surname" => "Smith",
        "First Name" => "John",
        "Date of Serum" => serum.collected_at,
        "Serum aliquot number" => 1,
        "Plasma aliquot number" => 2,
        "DNA aliquot number" => 0,
        "RNA aliquot number" => 3,
        "Urine aliquot number" => 1,
        "Urine with inhibitor aliquot number" => 0
      )
    end
  end
end
