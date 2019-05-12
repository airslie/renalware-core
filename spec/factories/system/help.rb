# frozen_string_literal: true

FactoryBot.define do
  factory :system_help, class: "Renalware::System::Help" do
    accountable
    name { Faker::File.file_name }
    description { Faker::Lorem.sentence }

    trait :with_file do
      after(:build) do |help|
        help.file.attach(
          io: File.open(Renalware::Engine.root.join("spec", "fixtures", "files", "README.md")),
          filename: "README.md",
          content_type: "text/markdown; charset=UTF-8"
        )
      end
    end
  end
end
