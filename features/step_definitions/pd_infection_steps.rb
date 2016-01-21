Given(/^a patient has PD$/) do
  FactoryGirl.create(:modality,
    patient: @patient_1,
    description: @modal_pd
    )

  visit patient_pd_summary_path(@patient_1)
end

