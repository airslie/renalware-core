describe Renalware::Heidi::Session do
  subject { build(:heidi_session) }

  it { is_expected.to belong_to(:patient).class_name("Renalware::Patient") }
  it { is_expected.to belong_to(:user).class_name("Renalware::User") }
  it { is_expected.to belong_to(:clinic_visit).class_name("Renalware::Clinics::ClinicVisit").optional }
  it { is_expected.to validate_uniqueness_of(:heidi_session_id) }

  it "allows a preparing launch record without remote Heidi IDs" do
    session = build(
      :heidi_session,
      status: :preparing,
      heidi_session_id: nil,
      heidi_patient_profile_id: nil
    )

    expect(session).to be_valid
  end

  it "allows a failed launch record without remote Heidi IDs" do
    session = build(
      :heidi_session,
      status: :launch_failed,
      heidi_session_id: nil,
      heidi_patient_profile_id: nil
    )

    expect(session).to be_valid
  end

  it "requires remote Heidi IDs once launched" do
    session = build(
      :heidi_session,
      status: :launched,
      heidi_session_id: nil,
      heidi_patient_profile_id: nil
    )

    expect(session).not_to be_valid
    expect(session.errors[:heidi_session_id]).to include("can't be blank")
    expect(session.errors[:heidi_patient_profile_id]).to include("can't be blank")
  end
end
