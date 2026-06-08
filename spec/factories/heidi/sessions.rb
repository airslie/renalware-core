FactoryBot.define do
  factory :heidi_session, class: "Renalware::Heidi::Session" do
    patient
    user
    heidi_session_id { SecureRandom.uuid }
    heidi_patient_profile_id { SecureRandom.uuid }
    status { :launched }
  end
end
