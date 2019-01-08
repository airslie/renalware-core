# frozen_string_literal: true

FactoryBot.define do
  factory :patient_attachment, class: "Renalware::Patients::Attachment" do
    accountable
    association :patient, factory: :patient
    association :attachment_type, factory: :patient_attachment_type
    name { Faker::File.file_name }
    description { Faker::Lorem.sentence }
    document_date { Faker::Date.between(1.year.ago, Time.zone.today) }

    trait :with_file do
      after(:build) do |attachment|
        attachment.file.attach(
          io: File.open(Renalware::Engine.root.join("spec", "fixtures", "files", "cat.png")),
          filename: "cat2.png",
          content_type: "image/png"
        )
      end
    end
  end
end
