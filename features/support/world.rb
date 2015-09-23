module DomainWorld
  def create_recipient_workup(user, patient)
    Renalware::Transplants::RecipientWorkup.create!(
      patient: patient,
      performed_at: 1.day.ago
    )
  end

  def recipient_workups_for(patient)
    Renalware::Transplants::RecipientWorkup.for_patient(patient)
  end
end

module WebWorld
  def create_recipient_workup(user, patient)
    login_as user
    visit clinical_summary_patient_path(patient)
    click_on "Recipient Workups"
    click_on "Add"

    select '2015', from: 'transplants_recipient_workup_performed_at_1i'
    select 'April', from: 'transplants_recipient_workup_performed_at_2i'
    select '2', from: 'transplants_recipient_workup_performed_at_3i'
    select '10', from: 'transplants_recipient_workup_performed_at_4i'
    select '30', from: 'transplants_recipient_workup_performed_at_5i'

    click_on "Save"
  end

  def recipient_workups_for(patient)
    all("tr.workup td:first-child").map { |node| node.text }
  end
end

if ENV['TEST_DEPTH'] == "Web"
  World(WebWorld)
else
  World(DomainWorld)
end