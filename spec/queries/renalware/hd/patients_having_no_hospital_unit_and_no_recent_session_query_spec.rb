# frozen_string_literal: true

RSpec.describe Renalware::HD::PatientsHavingNoHospitalUnitAndNoRecentSessionQuery do
  include PatientsSpecHelper

  let(:user) { create(:user) }
  let(:hospital_unit) { create(:hospital_unit) }

  before do
    allow(Renalware.config)
      .to receive(:hd_session_require_patient_group_directions)
      .and_return(false)
  end

  it "returns empty when there are no matching patients" do
    expect(described_class.call).to be_empty
  end

  it "returns HD patients having no hospital_unit in their hd_profile and whose latest " \
     "HD Session was > 31 days ago" do
    _patient_with_no_modality = create(:patient, by: user)
    _patient_with_pd_modality = create(:pd_patient, :with_pd_modality, by: user)
    hd_pat_w_unit_w_matching_last_session = create_hd_patient_with_modality
    hd_pat_no_unit_w_matching_last_session = create_hd_patient_with_modality
    hd_pat_no_unit_w_nonmatching_last_session = create_hd_patient_with_modality

    hd_pat_w_unit_w_matching_last_session.create_hd_profile!(
      prescriber: user,
      by: user,
      hospital_unit:
    )

    expect(hd_pat_w_unit_w_matching_last_session.hd_profile).to be_present
    expect(hd_pat_no_unit_w_matching_last_session.hd_profile).to be_nil
    expect(hd_pat_no_unit_w_nonmatching_last_session.hd_profile).to be_nil

    days_ago_32 = 32.days.ago

    create(
      :hd_closed_session,
      patient: hd_pat_no_unit_w_matching_last_session,
      started_at: days_ago_32
    )

    create(
      :hd_closed_session,
      patient: hd_pat_no_unit_w_matching_last_session,
      started_at: 100.days.ago
    )

    create(
      :hd_closed_session,
      patient: hd_pat_w_unit_w_matching_last_session,
      started_at: days_ago_32
    )

    create(
      :hd_closed_session,
      patient: hd_pat_no_unit_w_nonmatching_last_session,
      started_at: 27.days.ago
    )

    results = described_class.call.to_a

    expect(
      results.pluck(:patient_id)
    ).to eq([hd_pat_no_unit_w_matching_last_session.id])

    expect(results.first[:last_session_at].to_date).to eq(days_ago_32.to_date)
  end

  def create_hd_patient_with_modality
    create(:hd_patient, by: user).tap do |patient|
      set_modality(
        patient:,
        modality_description: create(:hd_modality_description),
        by: user
      )
    end
  end
end
