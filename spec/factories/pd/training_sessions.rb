FactoryBot.define do
  factory :pd_training_session, class: "Renalware::PD::TrainingSession" do
    accountable
    patient
    association :training_site, factory: :pd_training_site
    association :training_type, factory: :pd_training_type
    document {
      {
        started_on: Time.zone.today,
        trainer: "Flo Nightengale RN",
        outcome: :successful
      }
    }
  end
end
