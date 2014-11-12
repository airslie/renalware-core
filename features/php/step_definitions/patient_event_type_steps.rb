Given(/^they are adding a new patient event$/) do
  visit '/pat/patient.php?vw=encounters&zid=124502'
  click_on "add new encounter"
end
