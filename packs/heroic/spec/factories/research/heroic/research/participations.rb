# frozen_string_literal: true

FactoryBot.define do
  factory :heroic_participation, class: "Renalware::Heroic::Research::Participation" do
    association :by, factory: :user
    association :patient, factory: :patient
    association :study, factory: :heroic_research_study
    joined_on { "01-01-2018" }

    trait :active do
      document do
        {
          withdrawal: {
            status: "1_active"
          }
        }
      end
    end

    trait :inactive do
      document do
        {
          withdrawal: {
            status: "4_inactive"
          }
        }
      end
    end

    trait :complete_withdrawal do
      document do
        {
          withdrawal: {
            status: "3_complete_withdrawal"
          }
        }
      end
    end
  end
end
