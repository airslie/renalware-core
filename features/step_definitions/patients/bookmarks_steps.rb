Given(/^Clyde has the following patients bookmarked:$/) do |table|
  table.raw.flatten.map do |patient_name|
    create_bookmark(@clyde, patient_name)
  end
end

When(/^Clyde bookmarks (\w+)$/) do |patient_name|
  bookmark_patient(@clyde, patient_name)
end

When(/^Doug bookmarks (\w+)$/) do |patient_name|
  bookmark_patient(@doug, patient_name)
end

When(/^Clyde deletes the bookmark for (\w+)$/) do |patient_name|
  delete_bookmark(@clyde, patient_name)
end

Then(/^the following patients appear in Clyde's bookmarked patient list:$/) do |table|
  patients = table.raw.flatten.map do |given_name|
    Renalware::Patient.find_by(given_name: given_name)
  end

  expect_user_to_have_patients_in_bookmarks(@clyde, patients)
end
