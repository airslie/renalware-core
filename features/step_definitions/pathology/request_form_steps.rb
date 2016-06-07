When(/^Clyde enters clinic (.*)$/) do |clinic_name|
  @url_params = {} unless @url_params.present?
  clinic = Renalware::Clinics::Clinic.find_by!(name: clinic_name)
  @url_params.merge!(clinic_id: clinic.id)
end

When(/^Clyde enters doctor ([A-Za-z]+) ([A-Za-z]+)$/) do |given_name, family_name|
  @url_params = {} unless @url_params.present?
  doctor = Renalware::Doctor.find_by!(given_name: given_name, family_name: family_name)
  @url_params.merge!(doctor_id: doctor.id)
end

When(/^Clyde enters telephone number (\d*)$/) do |telephone|
  @url_params = {} unless @url_params.present?
  @url_params.merge!(telephone: telephone)
end

When(/^Clyde views the pathology request form for Patty$/) do
  login_as @clyde

  @url_params = {} unless @url_params.present?

  @url_params.merge!(patient_ids: @patty.id)
  url = pathology_forms_path(@url_params)

  visit url
end

Then(/^Clyde sees these details at the top of the form$/) do |table|
  html_table =
    find_by_id("patient_#{@patty.id}_summary")
      .all("tr")
      .map do |row|
        row.all("th, td").map { |cell| cell.text.strip }
      end

  expected_table = table.raw.map do |row|
    row.map do |cell|
      if cell == "TODAYS_DATE"
        Date.current.strftime("%d/%m/%Y")
      else
        cell
      end
    end
  end

  expect(html_table).to eq(expected_table)
end

Then(/^Clyde sees this patient specific test: (.*)$/) do |string|
  expect(page).to have_content(string)
end

Then(/^Clyde sees no global tests required$/) do
  expect(page).to have_content("No tests required.")
end

Then(/^Clyde sees the request description ([A-Z0-9]+) required$/) do |request_description_code|
  request_description =
    Renalware::Pathology::RequestDescription.find_by(code: request_description_code)
  expect(page.text.downcase).to include(request_description.name.downcase)
end
