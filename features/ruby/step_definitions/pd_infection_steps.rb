Given(/^there are organisms in the database$/) do
  @organism_codes = [["READ1", "Bacillis"], ["READ2", "E.Coli"], ["READ3", "MRSA"], ["READ4", "Strep"]]
  @organism_codes.map! do |oc|
    @organism_code = FactoryGirl.create(:organism_code, :read_code => oc[0], :name => oc[1])
  end

  @bacillis = @organism_codes[0]
  @e_coli = @organism_codes[1]
  @mrsa = @organism_codes[2]
  @strep = @organism_codes[3]
end

Given(/^there are episode types in the database$/) do
  @episode_types = ["De novo", "Recurrent", "Relapsing", "Repeat", "Refractory", "Catheter-related", "Other"]
  @episode_types.map! do |et|
    FactoryGirl.create(:episode_type, :term => et )
  end

  @de_novo = @episode_types[0]
  @recurrent = @episode_types[1]
  @relapsing = @episode_types[2]
  @repeat = @episode_types[3]
  @refractory = @episode_types[4]
  @catheter_related = @episode_types[5]
  @other = @episode_types[6]
end

Given(/^there are fluid descriptions in the database$/) do
  @fluid_descriptions = ["Clear", "Misty", "Cloudy", "Pea Soup"]
  @fluid_descriptions.map! do |fd|
    FactoryGirl.create(:fluid_description, :description => fd )
  end

  @clear = @fluid_descriptions[0]
  @misty = @fluid_descriptions[1]
  @cloudy = @fluid_descriptions[2]
  @pea_soup = @fluid_descriptions[3]
end

Given(/^a patient has PD$/) do
  visit pd_info_patient_path(@patient_1)
end

Given(/^a patient has a recently recorded episode of peritonitis$/) do

  @peritonitis_episode_1 = FactoryGirl.create(:peritonitis_episode,
    patient: @patient_1,
    diagnosis_date: "24/02/2015",
    treatment_start_date: "25/02/2015",
    treatment_end_date: "25/03/2015",
    episode_type: @de_novo,
    catheter_removed: 1,
    line_break: 1,
    exit_site_infection: 1,
    diarrhoea: 0,
    abdominal_pain: 0,
    fluid_description: @misty,
    white_cell_total: 2000,
    white_cell_neutro: 20,
    white_cell_lympho: 20,
    white_cell_degen: 30,
    white_cell_other: 30,
    notes: "Needs review in 6 weeks"
  )

end

Given(/^a patient has a recently recorded exit site infection$/) do
  @exit_site_1 = FactoryGirl.create(:exit_site_infection,
    patient: @patient_1,
    diagnosis_date: "01/01/2015",
    treatment: "Typical treatment.",
    outcome: "Ok outcome.",
    notes: "review treatment in a 6 weeks."
  )
end

Given(/^a patient has episodes of peritonitis$/) do

  @peritonitis_episode_2 = FactoryGirl.create(:peritonitis_episode,
    patient: @patient_1,
    diagnosis_date: "20/12/2015",
    treatment_start_date: "21/12/2015",
    treatment_end_date: "25/01/2015",
    episode_type: @relapsing,
    catheter_removed: 1,
    line_break: 1,
    exit_site_infection: 0,
    diarrhoea: 1,
    abdominal_pain: 0,
    fluid_description: @cloudy,
    white_cell_total: 1500,
    white_cell_neutro: 25,
    white_cell_lympho: 25,
    white_cell_degen: 25,
    white_cell_other: 25,
    notes: "Has problems getting rid of infection.",
    medications_attributes: [
      patient: @patient_1,
      medicatable: @amoxicillin,
      treatable: @peritonitis_episode_2,
      dose: "20mg",
      medication_route: @po,
      frequency: "daily",
      notes: "with food",
      date: "02/03/2015",
      provider: 0,
      deleted_at: "NULL",
      created_at: "2015-02-03 18:21:04",
      updated_at: "2015-02-05 18:21:04"
    ]
  )

  @infection_organism_1 = FactoryGirl.create(:infection_organism,
    organism_code: @mrsa,
    sensitivity: "Sensitive to MRSA.",
    created_at: "2015-03-03 15:30:00",
    updated_at: "2015-03-05 15:30:00"
  )

  @peritonitis_episode_2.infection_organisms << @infection_organism_1

  @peritonitis_episode_3 = FactoryGirl.create(:peritonitis_episode,
    patient: @patient_1,
    diagnosis_date: "24/01/2015",
    treatment_start_date: "25/01/2015",
    treatment_end_date: "27/02/2015",
    episode_type: @repeat,
    catheter_removed: 0,
    line_break: 1,
    exit_site_infection: 0,
    diarrhoea: 1,
    abdominal_pain: 1,
    fluid_description: @misty,
    white_cell_total: 3000,
    white_cell_neutro: 20,
    white_cell_lympho: 25,
    white_cell_degen: 30,
    white_cell_other: 25,
    notes: "Needs pain management.",
    medications_attributes: [
      patient: @patient_1,
      medicatable: @penicillin,
      treatable: @peritonitis_episode_3,
      dose: "50mg",
      medication_route: @sc,
      frequency: "PID",
      notes: "with water",
      date: "02/03/2015",
      provider: 0,
      deleted_at: "NULL",
      created_at: "2015-02-03 18:21:04",
      updated_at: "2015-02-05 18:21:04"
    ]
  )

  @infection_organism_2 = FactoryGirl.create(:infection_organism,
    organism_code: @strep,
    sensitivity: "Sensitive to strep.",
    created_at: "2015-03-03 15:30:00",
    updated_at: "2015-03-05 15:30:00"
  )

  @peritonitis_episode_3.infection_organisms << @infection_organism_2

end

Given(/^a patient has exit site infections$/) do

  @exit_site_2 = FactoryGirl.create(:exit_site_infection,
    patient: @patient_1,
    diagnosis_date: "25/01/2015",
    treatment: "Received treatment for this exit site infection.",
    outcome: "Outcome for this exit site infection is not good.",
    notes: "Needs time for review.",
    medications_attributes: [
      patient: @patient_1,
      medicatable: @dicloxacillin,
      treatable: @exit_site_2,
      dose: "10mg",
      medication_route: @im,
      frequency: "Twice a month",
      notes: "Has a cold.",
      date: "02/03/2015",
      provider: 0,
      deleted_at: "NULL",
      created_at: "2015-02-03 18:21:04",
      updated_at: "2015-02-05 18:21:04"
    ]
  )

  @infection_organism_3 = FactoryGirl.create(:infection_organism,
    organism_code: @bacillis,
    sensitivity: "Very sensitive to bacillis.",
    created_at: "2015-03-03 15:30:00",
    updated_at: "2015-03-05 15:30:00"
  )

  @exit_site_2.infection_organisms <<  @infection_organism_3

  @exit_site_3 = FactoryGirl.create(:exit_site_infection,
    patient: @patient_1,
    diagnosis_date: "26/01/2015",
    treatment: "Received treatment for this second exit site infection.",
    outcome: "Outcome for this second exit site infection is not good.",
    notes: "Needs more time for review.",
    medications_attributes: [
      patient: @patient_1,
      medicatable: @rifampin,
      treatable: @exit_site_3,
      dose: "30mg",
      medication_route: @iv,
      frequency: "BD",
      notes: "Review after 2 weeks",
      date: "02/03/2015",
      provider: 0,
      deleted_at: "NULL",
      created_at: "2015-02-03 18:21:04",
      updated_at: "2015-02-05 18:21:04"
    ]
  )

  @infection_organism_4 = FactoryGirl.create(:infection_organism,
    organism_code: @e_coli,
    sensitivity: "Very sensitive to E.Coli.",
    created_at: "2015-03-03 15:30:00",
    updated_at: "2015-03-05 15:30:00"
  )

  @exit_site_3.infection_organisms << @infection_organism_4

end

When(/^the Clinician records the episode of peritonitis$/) do
  click_on "Record an Episode of Peritonitis"

  within "#peritonitis_episode_diagnosis_date_3i" do
    select '25'
  end
  within "#peritonitis_episode_diagnosis_date_2i" do
    select 'December'
  end
  within "#peritonitis_episode_diagnosis_date_1i" do
    select '2014'
  end

  within "#peritonitis_episode_treatment_start_date_3i" do
    select '30'
  end
  within "#peritonitis_episode_treatment_start_date_2i" do
    select 'December'
  end
  within "#peritonitis_episode_treatment_start_date_1i" do
    select '2014'
  end

  within "#peritonitis_episode_treatment_end_date_3i" do
    select '31'
  end
  within "#peritonitis_episode_treatment_end_date_2i" do
    select 'January'
  end
  within "#peritonitis_episode_treatment_end_date_1i" do
    select '2015'
  end

  select "De novo", from: "Episode type"

  check "Catheter removed"

  uncheck "Line break"
  check "Exit site infection"
  check "Diarrhoea"
  check "Abdominal pain"

  select "Misty", from: "Fluid description"

  fill_in "White cell total", :with => 1000
  fill_in "Neutro (%)", :with => 20
  fill_in "Lympho (%)", :with => 30
  fill_in "Degen (%)", :with => 25
  fill_in "Other (%)", :with => 25

  fill_in "Episode notes", :with => "Review in a weeks time"

  # Add an organism and sensitvity
  click_on "Record a new organism and sensitivity"

  select "E.Coli", from: "Organism"
  fill_in "Sensitivity", with: "Low sensitivity to E.Coli."

  # Add an medication
  click_on "Add a new medication"

  select "Rifampin", from: "Select Drug (peritonitis drugs only)"
  fill_in "Dose", with: "2mg"
  select "SC", from: "Route"
  fill_in "Frequency & Duration", with: "BD"
  fill_in "Notes", with: "Review in 3 weeks."

  within "#peritonitis_episode_medications_attributes_0_date_3i" do
    select '28'
  end
  within "#peritonitis_episode_medications_attributes_0_date_2i" do
    select 'February'
  end
  within "#peritonitis_episode_medications_attributes_0_date_1i" do
    select '2015'
  end

  find("#peritonitis_episode_medications_attributes_0_provider_hospital").set(true)

  click_on "Save Peritonitis Episode"
end

When(/^the Clinician records an exit site infection$/) do
  visit new_patient_exit_site_infection_path(@patient_1)

  within "#exit_site_infection_diagnosis_date_3i" do
    select '1'
  end
  within "#exit_site_infection_diagnosis_date_2i" do
    select 'January'
  end
  within "#exit_site_infection_diagnosis_date_1i" do
    select '2015'
  end

  fill_in "Treatment notes", :with => "Special treatment."
  fill_in "Outcome notes", :with => "It is a good outcome."
  fill_in "General notes about this infection", :with => "Review in a weeks time."

  # Add an organism and sensitvity
  click_on "Record a new organism and sensitivity"

  select "MRSA", from: "Organism"
  fill_in "Sensitivity", with: "Medium sensitivity to MRSA."

  # Add an medication
  click_on "Add a new medication"

  select "Tobramycin", from: "Select Drug (exit site drugs only)"
  fill_in "Dose", with: "3mg"
  select "IM", from: "Route"
  fill_in "Frequency & Duration", with: "Daily"
  fill_in "Notes", with: "Review in 6 weeks."

  within "#exit_site_infection_medications_attributes_0_date_3i" do
    select '1'
  end
  within "#exit_site_infection_medications_attributes_0_date_2i" do
    select 'January'
  end
  within "#exit_site_infection_medications_attributes_0_date_1i" do
    select '2015'
  end

  find("#exit_site_infection_medications_attributes_0_provider_gp").set(true)

  click_on "Save Exit Site Infection"
end

When(/^a patient selects an episode of peritonitis view$/) do
  visit pd_info_patient_path(@patient_1)

  find("#view-pe-2").click
end

When(/^a patient selects an exit site infection to view$/) do
  visit pd_info_patient_path(@patient_1)

  find("#view-es-infection-2").click
end

When(/^the Clinician updates the episode of peritonitis$/) do
  visit edit_patient_peritonitis_episode_path(@patient_1, @peritonitis_episode_1.id)

  fill_in "Episode notes", :with => "On review, needs stronger antibiotics."

  click_on "Update Peritonitis Episode"
end

When(/^the Clinician updates an exit site infection$/) do
  visit edit_patient_exit_site_infection_path(@patient_1, @exit_site_1.id)

  fill_in "General notes about this infection", :with => "Needs a review in 2 weeks time."

  click_on "Update Exit Site Infection"
end

When(/^they add a medication to this episode of peritonitis$/) do
  visit edit_patient_peritonitis_episode_path(@patient_1, @peritonitis_episode_1.id)

  click_on "Add a new medication"

  select "Penicillin", from: "Select Drug (peritonitis drugs only)"
  fill_in "Dose", with: "5mg"
  select "IV", from: "Route"
  fill_in "Frequency & Duration", with: "PID"
  fill_in "Notes", with: "Review in 1 month."

  within "#peritonitis_episode_medications_attributes_0_date_3i" do
    select '28'
  end
  within "#peritonitis_episode_medications_attributes_0_date_2i" do
    select 'February'
  end
  within "#peritonitis_episode_medications_attributes_0_date_1i" do
    select '2015'
  end

  click_on "Update Peritonitis Episode"
end

When(/^they add a medication to this exit site infection$/) do
  visit edit_patient_exit_site_infection_path(@patient_1, @exit_site_1.id)

  click_on "Add a new medication"

  select "Tobramycin", from: "Select Drug (exit site drugs only)"
  fill_in "Dose", with: "10mg"
  select "PO", from: "Route"
  fill_in "Frequency & Duration", with: "Twice a week"
  fill_in "Notes", with: "Watch for improvement."

  within "#exit_site_infection_medications_attributes_0_date_3i" do
    select '10'
  end
  within "#exit_site_infection_medications_attributes_0_date_2i" do
    select 'April'
  end
  within "#exit_site_infection_medications_attributes_0_date_1i" do
    select '2015'
  end

  click_on "Update Exit Site Infection"
end

When(/^they record an organism and sensitivity to this episode of peritonitis$/) do
  visit edit_patient_peritonitis_episode_path(@patient_1, @peritonitis_episode_1.id)

  click_on "Record a new organism and sensitivity"

  select "Bacillis", from: "Organism"
  fill_in "Sensitivity", with: "Very sensitive to Bacillis."

  click_on "Update Peritonitis Episode"
end

When(/^they record an organism and sensitivity to this exit site infection$/) do
  visit edit_patient_exit_site_infection_path(@patient_1, @exit_site_1.id)

  click_on "Record a new organism and sensitivity"

  select "E.Coli", from: "Organism"
  fill_in "Sensitivity", with: "High sensitivity to E.Coli."

  click_on "Update Exit Site Infection"
end

Then(/^the recorded episode should be displayed on PD info page$/) do

  #dates
  expect(page).to have_content("25/12/2014")
  expect(page).to have_content("30/12/2014")
  expect(page).to have_content("31/01/2015")

  #outcome
  expect(page).to have_content("De novo")
  expect(page).to have_content("Catheter Removed: Yes")

  #organism
  expect(page).to have_content("E.Coli")

  #causes/symptoms
  expect(page).to have_content("Line Break: No")
  expect(page).to have_content("Exit Site Infection: Yes")
  expect(page).to have_content("Diarrhoea: Yes")
  expect(page).to have_content("Abdominal Pain: Yes")
  expect(page).to have_content("Misty")

  #whitecells
  expect(page).to have_content("1000")
  expect(page).to have_content("Neutro: 20%")
  expect(page).to have_content("Lympho: 30%")
  expect(page).to have_content("Degen: 25%")
  expect(page).to have_content("Other: 25%")

  #medication/route
  expect(page).to have_content("Rifampin")
  expect(page).to have_content("SC")

end

Then(/^the recorded exit site infection should be displayed on PD info page$/) do

  #dates
  expect(page).to have_content("01/01/2015")

  #outcome
  expect(page).to have_content("It is a good outcome.")

  #organism
  expect(page).to have_content("MRSA")

  #treatment
  expect(page).to have_content("Special treatment.")

  #medication/route
  expect(page).to have_content("Tobramycin")
  expect(page).to have_content("IM")

  #notes
  expect(page).to have_content("Review in a weeks time.")

end

Then(/^an episode of peritonitis can be viewed in more detail from the PD info page$/) do
  expect(page).to have_content("24/01/2015")
  expect(page).to have_content("25/01/2015")
  expect(page).to have_content("27/02/2015")
  expect(page).to have_content("Misty")
  expect(page).to have_content("3000")
  expect(page).to have_content("25")
  expect(page).to have_content("20")
  expect(page).to have_content("30")
  expect(page).to have_content("3000")
  expect(page).to have_content("Needs pain management.")

  #medication/route
  expect(page).to have_content("Penicillin")
  expect(page).to have_content("SC")

  #organism/sensitivity
  expect(page).to have_content("Strep")
  expect(page).to have_content("Sensitive to strep")
end

Then(/^an exit site infection can be viewed in more detail from the PD info page$/) do
  expect(page).to have_content("26/01/2015")
  expect(page).to have_content("Received treatment for this second exit site infection.")
  expect(page).to have_content("Outcome for this second exit site infection is not good.")
  expect(page).to have_content("Needs more time for review.")

  #medication/route
  expect(page).to have_content("Rifampin")
  expect(page).to have_content("IV")

  #organism/sensitivity
  expect(page).to have_content("E.Coli")
  expect(page).to have_content("Very sensitive to E.Coli.")
end

Then(/^the updated peritonitis episode should be displayed on PD info page$/) do
  @peritonitis_episode_1.reload

  expect(page).to have_content("On review, needs stronger antibiotics.")
end

Then(/^the updated exit site infection should be displayed on PD info page$/) do
  @exit_site_1.reload

  expect(page).to have_content("Needs a review in 2 weeks time.")
end

Then(/^the new medication should be displayed on the updated peritonitis form$/) do
  visit edit_patient_peritonitis_episode_path(@patient_1, @peritonitis_episode_1.id)

  expect(page).to have_content("Penicillin")
  expect(page).to have_content("5mg")
  expect(page).to have_content("IV")
  expect(page).to have_content("PID")
  expect(page).to have_content("28/02/2015")
end

Then(/^the new medication should be displayed on the updated exit site form$/) do
  visit edit_patient_exit_site_infection_path(@patient_1, @exit_site_1.id)

  expect(page).to have_content("Tobramycin")
  expect(page).to have_content("10mg")
  expect(page).to have_content("PO")
  expect(page).to have_content("Twice a week")
  expect(page).to have_content("10/04/2015")
end

Then(/^the recorded organism and sensitivity should be displayed on the updated peritonitis form$/) do
  visit edit_patient_peritonitis_episode_path(@patient_1, @peritonitis_episode_1.id)

  expect(page).to have_content("Bacillis")
  expect(page).to have_content("Very sensitive to Bacillis.")
end

Then(/^the recorded organism and sensitivity should be displayed on the updated exit site form$/) do
  visit edit_patient_exit_site_infection_path(@patient_1, @exit_site_1.id)

  expect(page).to have_content("E.Coli")
  expect(page).to have_content("High sensitivity to E.Coli.")
end
