# GIVEN

Given(/^Clyde has the following patients bookmarked:$/) do |table|
  table.raw.flatten.map do |patient_name|
    create_bookmark(user: @clyde, patient_name: patient_name)
  end
end

Given(/^Doug bookmarked (\w+)$/) do |patient_name|
  create_bookmark(user: @doug, patient_name: patient_name)
end

# WHEN

When(/^Clyde bookmarks (\w+)$/) do |patient_name|
  bookmark_patient(user: @clyde, patient_name: patient_name)
end
When(/^Clyde bookmarks (\w+) with the note "([^"]*)" and indicates it is (urgent|not urgent)$/) do |patient_name, notes, urgent|
  bookmark_patient(user: @clyde,
                   patient_name: patient_name,
                   notes: notes,
                   urgent: urgent == "urgent")
end

When(/^Clyde deletes the bookmark for (\w+)$/) do |patient_name|
  delete_bookmark(user: @clyde, patient_name: patient_name)
end

# THEN

Then(/^the following patients appear in Clyde's bookmarked patient list:$/) do |table|
  # patients = table.raw.flatten.map do |given_name|
  #   Renalware::Patient.find_by(given_name: given_name)
  # end
  # expect_user_to_have_patients_in_bookmarks(@clyde, patients)

  table.hashes.each do |row|
    expect_user_to_have_patient_in_bookmarks(user: @clyde,
                                             patient_name: row[:Patient],
                                             notes: row[:Notes],
                                             urgent: row[:Urgent])
  end
end
