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

    trait(:draft) do
      state "draft"
    end

    trait(:ready_for_review) do
      state "ready_for_review"
    end

    trait(:archived) do
      state "archived"
    end
  end
end
