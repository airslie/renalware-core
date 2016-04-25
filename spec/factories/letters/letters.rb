FactoryGirl.define do
  factory :letter, class: "Renalware::Letters::Letter" do
    issued_on Time.zone.today
    state "draft"
    description "This is a custom description"
    body "I am pleased to report a marked improvement in her condition."

    association :patient, factory: [:letter_patient], cc_on_all_letters: true
    association :author, factory: [:user, :author]
    association :letterhead, factory: [:letter_letterhead]

    association :created_by, factory: :user
    association :updated_by, factory: :user

    trait(:ready_for_review) do
      state "ready_for_review"
    end

    trait(:archived) do
      state "archived"
    end

    trait :to_doctor do
      after(:build) do |letter|
        letter.main_recipient = build(:letter_main_recipient, source_type: "Renalware::Doctor")
      end
      after(:create) do |letter|
        letter.cc_recipients = [build(:letter_cc_recipient, source: letter.patient)]
      end
    end

    trait :to_patient do
      after(:build) do |letter|
        letter.main_recipient = build(:letter_main_recipient, source_type: "Renalware::Patient")
      end
      after(:create) do |letter|
        letter.cc_recipients = [build(:letter_cc_recipient, source: letter.patient.doctor)]
      end
    end

    trait :to_someone_else do
      after(:build) do |letter|
        letter.main_recipient = build(:letter_main_recipient, source: nil,
          name: "John Doe", address: build(:address)
        )
      end
      after(:create) do |letter|
        letter.cc_recipients = [
          build(:letter_cc_recipient, source: letter.patient.doctor),
          build(:letter_cc_recipient, source: letter.patient)
        ]
      end
    end
  end
end
