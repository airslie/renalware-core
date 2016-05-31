When(/^Clyde views the pathology request form for Patty$/) do
  @url_params = { patient_ids: @patty.id }
end

When(/^Clyde selects clinic (.*)$/) do |clinic_name|
  clinic = Renalware::Clinics::Clinic.find_by(name: clinic_name)
  @url_params.merge!(clinic_id: clinic.id)
end

When(/^Clyde selects doctor ([A-Za-z]+) ([A-Za-z]+)$/) do |given_name, family_name|
  #byebug
  #doctor = Renalware::Doctor.find_by()
end

When(/^Clyde selects telephone number (\d+)$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^Clyde sees these details at the top of the form$/) do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
  # url = pathology_forms_path
end
