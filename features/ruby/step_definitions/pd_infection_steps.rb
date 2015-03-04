Given(/^there are organisms in the database$/) do
  @organism_codes = [["READ1", "Bacillis"], ["READ2", "E.Coli"], ["READ3", "MRSA"], ["READ4", "Strep"]]
  @organism_codes.map! do |oc|
    @organism_code = OrganismCode.create!(:read_code => oc[0], :name => oc[1])
  end
end

Given(/^a patient has PD$/) do
  visit pd_info_patient_path(@patient)
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

  fill_in "Episode type", :with => 3
  
  check "Catheter removed"
  
  uncheck "Line break"
  check "Exit site infection"
  check "Diarrhoea"
  check "Abdominal pain"

  fill_in "Fluid description", :with => 7
  fill_in "White cell total", :with => 1000
  fill_in "Neutro (%)", :with => 20
  fill_in "Lympho (%)", :with => 30
  fill_in "Degen (%)", :with => 25
  fill_in "Other (%)", :with => 25

  select "Bacillis", from: "Organism 1"
  select "E.Coli", from: "Organism 2"

  fill_in "Notes", :with => "Review in a weeks time"

  fill_in "Antibiotic 1", :with => 11
  fill_in "Antibiotic 2", :with => 12
  fill_in "Antibiotic 3", :with => 13
  fill_in "Antibiotic 4", :with => 14
  fill_in "Antibiotic 5", :with => 15

  select "PO", from: "Route (Antibiotic 1)"
  select "IV", from: "Route (Antibiotic 2)"
  select "SC", from: "Route (Antibiotic 3)"
  select "IM", from: "Route (Antibiotic 4)"
  select "Other (Please specify in notes)", from: "Route (Antibiotic 5)"
  
  fill_in "Sensitivities (Antibiotics)", :with => "Antibiotic 1 most effective."

  click_on "Save Peritonitis Episode"

end

Then(/^the recorded episode should be displayed on PD info page$/) do

  expect(page.has_content? "25/12/2014").to be true
  expect(page.has_content? "30/12/2014").to be true
  expect(page.has_content? "31/01/2015").to be true
  
  expect(page.has_content? "3").to be true
  
  expect(page.has_content? "Catheter Removed: true").to be true
  expect(page.has_content? "Line Break: false").to be true
  expect(page.has_content? "Exit Site Infection: true").to be true
  expect(page.has_content? "Diarrhoea: true").to be true
  expect(page.has_content? "Abdominal Pain: true").to be true
  
  expect(page.has_content? "7").to be true
  
  expect(page.has_content? "1000").to be true
  expect(page.has_content? "Neutro: 20%").to be true
  expect(page.has_content? "Lympho: 30%").to be true
  expect(page.has_content? "Degen: 25%").to be true
  expect(page.has_content? "Other: 25%").to be true
  
  expect(page.has_content? "Bacillis").to be true
  expect(page.has_content? "E.Coli").to be true
  
  expect(page.has_content? "Antibiotic: 11").to be true
  expect(page.has_content? "Route: PO").to be true
  expect(page.has_content? "Antibiotic: 12").to be true
  expect(page.has_content? "Route: IV").to be true
  expect(page.has_content? "Antibiotic: 13").to be true
  expect(page.has_content? "Route: SC").to be true
  expect(page.has_content? "Antibiotic: 14").to be true
  expect(page.has_content? "Route: IM").to be true
  expect(page.has_content? "Antibiotic: 15").to be true 
  expect(page.has_content? "Route: Other (Please specify in notes)").to be true
  
  expect(page.has_content? "Antibiotic 1 most effective.").to be true
  
end

Given(/^a patient has a recently recorded episode of peritonitis$/) do
  @peritonitis_episode = PeritonitisEpisode.create!( 
    patient_id: 1,         
    user_id: 1,              
    diagnosis_date: "24/02/15",
    start_treatment_date: "25/02/15", 
    end_treatment_date: "25/03/2015",
    episode_type: 1,         
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
    organism_1_id: 3,           
    organism_2_id: 4,           
    notes: "Needs review in 6 weeks",                
    antibiotic_1_id: 1,         
    antibiotic_2_id: 3,         
    antibiotic_3_id: 4,         
    antibiotic_4_id: 8,         
    antibiotic_5_id: 10,         
    antibiotic_1_route: 1,   
    antibiotic_2_route: 2,   
    antibiotic_3_route: 1,   
    antibiotic_4_route: 2,   
    antibiotic_5_route: 2,   
    sensitivities: "Need to monitor antibiotic 1"        
  )
end

When(/^the Clinician updates the episode of peritonitis$/) do
  visit edit_patient_peritonitis_episode_path(@patient, @peritonitis_episode.id)
  
  select "Bacillis", from: "Organism 1"
  fill_in "Notes", :with => "On review, needs stronger antibiotics."

  click_on "Update Peritonitis Episode"
end

Then(/^the updated episode should be displayed on PD info page$/) do
  @peritonitis_episode.reload
  expect(page.has_content? "6").to be true
  expect(page.has_content? "On review, needs stronger antibiotics.").to be true
end

When(/^the Clinician records an exit site infection$/) do
  visit new_patient_exit_site_infection_path(@patient)

  within "#exit_site_infection_diagnosis_date_3i" do
    select '1'
  end
  within "#exit_site_infection_diagnosis_date_2i" do
    select 'January'
  end
  within "#exit_site_infection_diagnosis_date_1i" do
    select '2015'
  end

  select "MRSA", from: "Organism 1"
  select "Strep", from: "Organism 2"

  fill_in "Treatment", :with => "Special treatment."
  fill_in "Outcome", :with => "It is a good outcome."
  fill_in "Notes", :with => "Review in a weeks time."

  fill_in "Antibiotic 1", :with => 8
  fill_in "Antibiotic 2", :with => 9
  fill_in "Antibiotic 3", :with => 10
  
  select "PO", from: "Route (Antibiotic 1)"
  select "IV", from: "Route (Antibiotic 2)"
  select "SC", from: "Route (Antibiotic 3)"

  fill_in "Sensitivities", :with => "All showing good response."

  click_on "Save Exit Site Infection"
end

Then(/^the recorded exit site infection should be displayed on PD info page$/) do

  expect(page.has_content? "01/01/2015").to be true

  expect(page.has_content? "MRSA").to be true
  expect(page.has_content? "Strep").to be true

  expect(page.has_content? "Special treatment.").to be true
  expect(page.has_content? "It is a good outcome.").to be true
  expect(page.has_content? "Review in a weeks time.").to be true
  
  expect(page.has_content? "8").to be true
  expect(page.has_content? "9").to be true
  expect(page.has_content? "10").to be true

  expect(page.has_content? "PO").to be true
  expect(page.has_content? "IV").to be true
  expect(page.has_content? "SC").to be true
  
  expect(page.has_content? "All showing good response.").to be true
end

Given(/^a patient has a recently recorded exit site infection$/) do
  @exit_site_infection = ExitSiteInfection.create!(
    patient_id: 1,
    user_id: 1,            
    diagnosis_date: "01/01/2015",
    organism_1_id: 1,         
    organism_2_id: 2,         
    treatment: "Typical treatment.",         
    outcome: "Ok outcome.",           
    notes: "review treatment in a 6 weeks.",             
    antibiotic_1_id: 1,       
    antibiotic_2_id: 2,       
    antibiotic_3_id: 3,       
    antibiotic_1_route: 2, 
    antibiotic_2_route: 1, 
    antibiotic_3_route: 2, 
    sensitivities: "All antibiotics responding well."
  )
end

When(/^the Clinician updates an exit site infection$/) do
  visit edit_patient_exit_site_infection_path(@patient, @exit_site_infection.id)

  select "MRSA", from: "Organism 2"
  fill_in "Notes", :with => "Needs a review in 2 weeks time."

  click_on "Update Exit Site Infection"
end

Then(/^the updated exit site infection should be displayed on PD info page$/) do
  @exit_site_infection.reload

  expect(page.has_content? "12").to be true
  expect(page.has_content? "Needs a review in 2 weeks time.").to be true
end

