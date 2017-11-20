FactoryBot.define do
  factory :letter, class: "Renalware::Letters::Letter" do
    accountable

    issued_on { Time.zone.today }
    description "This is a custom description"
    body "I am pleased to report a marked improvement in her condition."

    association :letterhead, factory: [:letter_letterhead]

    author { accountable_actor }

    factory :draft_letter, class: "Renalware::Letters::Letter::Draft" do
    end

    factory :pending_review_letter, class: "Renalware::Letters::Letter::PendingReview" do
    end

    factory :approved_letter, class: "Renalware::Letters::Letter::Approved" do
    end

    factory :completed_letter, class: "Renalware::Letters::Letter::Completed" do
    end
  end
end
