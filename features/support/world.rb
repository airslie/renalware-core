module DomainWorld
  def create_recipient_workup(_user, patient)
    Renalware::Transplants::RecipientWorkup.create!(
      patient: patient,
      performed_at: 1.day.ago
    )
  end

  def update_workup(workup, _user, updated_at)
    workup.update_attributes(
      document_attributes: {
        hx_tb: true
      },
      updated_at: updated_at
    )
  end

  def recipient_workups_for(patient)
    Renalware::Transplants::RecipientWorkup.for_patient(patient)
  end

  def workups_updated_at(patient, timestamp)
    Renalware::Transplants::RecipientWorkup.for_patient(patient).where(updated_at: timestamp)
  end
end

module WebWorld
  def create_recipient_workup(user, patient)
    login_as user
    visit clinical_summary_patient_path(patient)
    click_on "Recipient Workups"
    click_on "Add workup"

    select "2015", from: "transplants_recipient_workup_performed_at_1i"
    select "April", from: "transplants_recipient_workup_performed_at_2i"
    select "2", from: "transplants_recipient_workup_performed_at_3i"
    select "10", from: "transplants_recipient_workup_performed_at_4i"
    select "30", from: "transplants_recipient_workup_performed_at_5i"

    click_on "Save"
  end

  def update_workup(workup, user, _updated_at)
    login_as user
    visit clinical_summary_patient_path(workup.patient)
    click_on "Recipient Workups"
    find("#transplants_recipient_workup_#{workup.id} a", text: "Edit").click

    fill_in "Cervical smear result", with: "193"

    click_on "Save"
  end

  def recipient_workups_for(_patient)
    all("tr.workup td:first-child").map { |node| node.text }
  end

  def workups_updated_at(_patient, timestamp)
    text = I18n.l timestamp, format: :long
    all("tr.workup td", text: text).map { |node| node.text }
  end
end

if ENV["TEST_DEPTH"] == "web"
  World(WebWorld)
else
  World(DomainWorld)
end
