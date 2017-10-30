FactoryBot.define do
  factory :access_plan, class: Renalware::Accesses::Plan do
    accountable
    association :patient, factory: :accesses_patient
    association :plan_type, factory: :access_plan_type
    notes "Lorem ipsum dolor sit amet.."
    decided_by { accountable_actor }
    terminated_at nil
  end
end
