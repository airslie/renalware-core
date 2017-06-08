FactoryGirl.define do
  factory :pd_training_session, class: "Renalware::PD::TrainingSession" do
    patient
    association :updated_by, factory: :user
    association :created_by, factory: :user
    association :training_site, factory: :pd_training_site
    document {
      {
        started_on: Time.zone.today,
        trainer: "Flo Nightengale RN",
        training_type: :apd_baxter,
        outcome: :successful
      }
    }
  end
end
