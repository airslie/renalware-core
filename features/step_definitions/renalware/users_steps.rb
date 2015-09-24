Given(/^Clyde is a clinician$/) do
  @clyde = FactoryGirl.create(
    :user, :approved, :clinician,
    first_name: "Clyde", last_name: "TheClinician"
  )
end
