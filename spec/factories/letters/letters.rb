FactoryGirl.define do
  factory :letter, class: "Renalware::Letters::Letter" do
    issued_on Time.zone.today
    description "This is a custom description"
    body "I am pleased to report a marked improvement in her condition."

    association :author, factory: [:user, :author]
    association :letterhead, factory: [:letter_letterhead]

    association :created_by, factory: :user
    association :updated_by, factory: :user
  end

  factory :draft_letter, class: "Renalware::Letters::Letter::Draft", parent: :letter do
  end

  factory :typed_letter, class: "Renalware::Letters::Letter::Typed", parent: :letter do
  end

  factory :archived_letter, class: "Renalware::Letters::Letter::Archived", parent: :letter do
  end
end
