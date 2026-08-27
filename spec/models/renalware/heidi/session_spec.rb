describe Renalware::Heidi::Session do
  subject { build(:heidi_session) }

  it { is_expected.to belong_to(:patient).class_name("Renalware::Patient") }
  it { is_expected.to belong_to(:user).class_name("Renalware::User") }
  it { is_expected.to belong_to(:clinic_visit).class_name("Renalware::Clinics::ClinicVisit").optional }
  it { is_expected.to validate_presence_of(:heidi_session_id) }
  it { is_expected.to validate_presence_of(:heidi_patient_profile_id) }
  it { is_expected.to validate_uniqueness_of(:heidi_session_id) }
end
