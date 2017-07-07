FactoryGirl.define do
  factory :access_plan, class: Renalware::Accesses::Plan do
    association :patient, factory: :accesses_patient
    association :plan_type, factory: :access_plan_type
    notes "Lorem ipsum dolor sit amet.."
    created_by { Renalware::User.first || create(:user) }
    updated_by { Renalware::User.first || create(:user) }
    decided_by { Renalware::User.first || create(:user) }
    terminated_at nil
  end
end
