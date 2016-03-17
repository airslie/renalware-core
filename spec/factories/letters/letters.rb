FactoryGirl.define do
  factory :letter, class: "Renalware::Letters::Letter" do
    issued_on Time.zone.today
    state "draft"
    description "This is a custom description"
    body "I am pleased to report a marked improvement in her condition."

    association :patient, factory: [:letter_patient]
    association :author, factory: [:user, :author]
    association :letterhead, factory: [:letter_letterhead]

    association :created_by, factory: :user
    association :updated_by, factory: :user

    after(:build) do |letter|
      letter.main_recipient = build(:letter_main_recipient)
    end

    trait(:ready_for_review) do
      state "ready_for_review"
    end

    trait(:archived) do
      state "archived"
    end

    factory :letter_to_doctor do
      after(:build) do |letter|
        letter.main_recipient = build(:letter_main_recipient, source: build(:doctor))
      end
    end

    factory :letter_to_patient do
      after(:build) do |letter|
        letter.main_recipient = build(:letter_main_recipient, source: letter.patient)
      end
    end
  end
end
