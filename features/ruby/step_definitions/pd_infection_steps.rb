Given(/^there are organisms in the database$/) do
  @organism_codes = [["READ1", "Bacillis"], ["READ2", "E.Coli"], ["READ3", "MRSA"], ["READ4", "Strep"]]
  @organism_codes.map! do |oc|
    @organism_code = OrganismCode.create!(:read_code => oc[0], :name => oc[1])
  end
end

Given(/^there are episode types in the database$/) do
  @episode_types = ["De novo", "Recurrent", "Relapsing", "Repeat", "Refractory", "Catheter-related", "Other"]
  @episode_types.map! do |et|
    EpisodeType.create!( :term => et )
  end
end

Given(/^there are fluid descriptions in the database$/) do
  @fluid_descriptions = ["Clear", "Misty", "Cloudy", "Pea Soup"]
  @fluid_descriptions.map! do |fd|
    FluidDescription.create!( :description => fd )
  end
end

Given(/^a patient has a recently recorded episode of peritonitis$/) do

  @peritonitis_episode = PeritonitisEpisode.create!( 
    patient_id: @patient_1.id,             
    diagnosis_date: "24/02/2015",
    start_treatment_date: "25/02/2015", 
    end_treatment_date: "25/03/2015",
    episode_type_id: 1,         
    catheter_removed: 1,     
    line_break: 1,           
    exit_site_infection: 1,  
    diarrhoea: 0,            
    abdominal_pain: 0,       
    fluid_description_id: 2,    
    white_cell_total: 2000,     
    white_cell_neutro: 20,    
    white_cell_lympho: 20,    
    white_cell_degen: 30,     
    white_cell_other: 30,              
    notes: "Needs review in 6 weeks"       
  )

end

Given(/^a patient has PD$/) do
  visit pd_info_patient_path(@patient_1)
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
  
  within "#peritonitis_episode_start_treatment_date_3i" do
    select '30'
  end
  within "#peritonitis_episode_start_treatment_date_2i" do
    select 'December'
  end
  within "#peritonitis_episode_start_treatment_date_1i" do
    select '2014'
  end
  
  within "#peritonitis_episode_end_treatment_date_3i" do
    select '31'
  end
  within "#peritonitis_episode_end_treatment_date_2i" do
    select 'January'
  end
  within "#peritonitis_episode_end_treatment_date_1i" do
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
  
  click_on "Save Peritonitis Episode"
end

Then(/^the recorded episode should be displayed on PD info page$/) do

  expect(page).to have_content("25/12/2014")
  expect(page).to have_content("30/12/2014")
  expect(page).to have_content("31/01/2015")
  
  expect(page).to have_content("De novo")
  
  expect(page).to have_content("Catheter Removed: true")
  expect(page).to have_content("Line Break: false")
  expect(page).to have_content("Exit Site Infection: true")
  expect(page).to have_content("Diarrhoea: true")
  expect(page).to have_content("Abdominal Pain: true")
  
  expect(page).to have_content("Misty")
  
  expect(page).to have_content("1000")
  expect(page).to have_content("Neutro: 20%")
  expect(page).to have_content("Lympho: 30%")
  expect(page).to have_content("Degen: 25%")
  expect(page).to have_content("Other: 25%")
  
end

When(/^the Clinician updates the episode of peritonitis$/) do
  visit edit_patient_peritonitis_episode_path(@patient_1, @peritonitis_episode.id)
  
  fill_in "Episode notes", :with => "On review, needs stronger antibiotics."

  click_on "Update Peritonitis Episode"
end

When(/^they add a medication to this episode of peritonitis$/) do
  visit edit_patient_peritonitis_episode_path(@patient_1, @peritonitis_episode.id)
  
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

When(/^they record an organism and sensitivity to this episode of peritonitis$/) do
  visit edit_patient_peritonitis_episode_path(@patient_1, @peritonitis_episode.id)
  
  click_on "Record a new organism and sensitivity"

  select "Bacillis", from: "Organism"
  fill_in "Sensitivity", with: "Very sensitive to Bacillis."
  
  click_on "Update Peritonitis Episode"
end

Then(/^the updated episode should be displayed on PD info page$/) do
  @peritonitis_episode.reload
  expect(page).to have_content("On review, needs stronger antibiotics.")
end

Then(/^the new medication should be displayed on the updated peritonitis form$/) do
  visit edit_patient_peritonitis_episode_path(@patient_1, @peritonitis_episode.id)
  expect(page).to have_content("Penicillin")
  expect(page).to have_content("5mg")
  expect(page).to have_content("IV")
  expect(page).to have_content("PID")
  expect(page).to have_content("2015-02-28")
end

Then(/^the recorded organism and sensitivity should be displayed on the updated peritonitis form$/) do
  visit edit_patient_peritonitis_episode_path(@patient_1, @peritonitis_episode.id)

  expect(page).to have_content("Bacillis")
  expect(page).to have_content("Very sensitive to Bacillis.")
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

  fill_in "Treatment", :with => "Special treatment."
  fill_in "Outcome", :with => "It is a good outcome."
  fill_in "Notes", :with => "Review in a weeks time."

  click_on "Save Exit Site Infection"
end

Then(/^the recorded exit site infection should be displayed on PD info page$/) do

  expect(page).to have_content("01/01/2015")
  expect(page).to have_content("Special treatment.")
  expect(page).to have_content("It is a good outcome.")
  expect(page).to have_content("Review in a weeks time.")

end

Given(/^a patient has a recently recorded exit site infection$/) do
  @exit_site_infection = ExitSiteInfection.create!(
    patient_id: @patient_1,
    user_id: 1,            
    diagnosis_date: "01/01/2015",        
    treatment: "Typical treatment.",         
    outcome: "Ok outcome.",           
    notes: "review treatment in a 6 weeks."
  )
end

When(/^the Clinician updates an exit site infection$/) do
  visit edit_patient_exit_site_infection_path(@patient_1, @exit_site_infection.id)

  fill_in "Notes", :with => "Needs a review in 2 weeks time."

  click_on "Update Exit Site Infection"
end

Then(/^the updated exit site infection should be displayed on PD info page$/) do
  @exit_site_infection.reload

  expect(page).to have_content("Needs a review in 2 weeks time.")
end

