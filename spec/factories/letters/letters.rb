FactoryGirl.define do
  factory :letter, class: "Renalware::Letters::Letter" do
    patient
    issued_on Time.zone.today
    state "draft"
    description "This is a custom description"
    body "I am pleased to report a marked improvement in her condition."
    # signature "Dr. D.O. Good"

    association :author, factory: [:user, :author]
    association :letterhead, factory: [:letter_letterhead]

    association :created_by,  factory: :user
    association :updated_by,  factory: :user

    trait(:ready_for_review) do
      state "ready_for_review"
    end

    trait(:archived) do
      state "archived"
    end

    # trait(:death) do
    #   letter_type "death"
    # end

    # trait(:discharge) do
    #   letter_type "discharge"
    # end

    # trait(:simple) do
    #   letter_type "simple"
    # end
  end
end
