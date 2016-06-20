Given(/^Clyde has the following patients bookmarked:$/) do |table|
  patients = table.raw.flatten.map do |patient_name|
    given_name, family_name = patient_name.split(" ")
    create_bookmark(@clyde, given_name, family_name)
  end
end

When(/^Clyde bookmarks (\w+) (\w+)$/) do |patient_given_name, patient_family_name|
  record_bookmark(@clyde, patient_given_name, patient_family_name)
end

When(/^Clyde deletes the bookmark for (\w+) (\w+)$/) do |patient_given_name, patient_family_name|
  delete_bookmark(@clyde, patient_given_name, patient_family_name)
end


Then(/^the following patients appear in Clyde's bookmarked patient list:$/) do |table|
  patients = table.raw.flatten.map do |patient_name|
    given_name, family_name = patient_name.split(" ")
    Renalware::Patient.find_by(given_name: given_name, family_name: family_name)
  end

  expect_user_to_have_patients_in_bookmarks(@clyde, patients)
end
