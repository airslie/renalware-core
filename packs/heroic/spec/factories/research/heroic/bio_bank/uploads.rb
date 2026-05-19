# frozen_string_literal: true

FactoryBot.define do
  factory :bio_bank_upload, class: "Renalware::Heroic::BioBank::Upload" do
    accountable

    file {
      Rack::Test::UploadedFile.new(
        Renalware::Heroic::Engine.root.join(
          "spec", "fixtures", "files", "biobank", "uploads", "samples_test.xlsx"
        ),
        "application/xls"
      )
    }

    staged_changes {
      [
        {
          "isbt" => "GG221719000001",
          "location" => "/C8/A/T10/B6/F12",
          "sample_type" => "SER",
          "aliquot_isbt" => "G22171900000101",
          "collected_at" => "2019-01-01T10:00:00.000+00:00",
          "processed_at" => "2019-01-01T14:00:00.000+00:00",
          "patient_identifier" => "HEROIC_RFH_001"
        }
      ]
    }

    factory :bio_bank_usage_upload do
      staged_changes {
        [
          {
            sample_type: "SER",
            aliquot_isbt: "G22171900000101",
            patient_identifier: "HEROIC_RFH_001",
            used_at: "28/03/2019",
            study_name: "Coward",
            notes: "Notes1"
          },
          {
            sample_type: "E-PLA",
            aliquot_isbt: "G22171900000119",
            patient_identifier: "HEROIC_RFH_001",
            used_at: "28/03/2019",
            study_name: "Coward",
            notes: "Notes2"
          }
        ]
      }
    end
  end
end
