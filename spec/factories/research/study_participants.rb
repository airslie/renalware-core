FactoryGirl.define do
  factory :research_study_participant, class: "Renalware::Research::StudyParticipant" do
    association :study, factory: :research_study
    association :patient, factory: :patient
    joined_on Time.zone.today
  end
end
