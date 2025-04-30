# WIP
module Renalware
  module DirectorySteps
    attr_reader :user, :person

    step :create_person,  "A person exists in the directory"
    step :add_person,     ":name adds a person to the directory"
    step :person_exists,  "the directory includes the person"

    def create_person(given_name: "X", family_name: "Y")
      @user ||= create(:user)
      @person = create(:directory_person, given_name: given_name, family_name: family_name, by: user)
    end

    def add_person(_name)
      @user ||= create(:user)
      @person = create(:directory_person, by: user)
    end

    def person_exists
      expect(@person.reload).to be_present
    end
  end
end

# Given /A person exists in the directory/ do
#   seed_person(user: Renalware::User.first)
# end

# Given /Sam is a social worker/ do
#   @sam = seed_person(given_name: "Sam", user: Renalware::User.first)
# end

# When /Clyde adds a person to the directory/ do
#   create_person(user: @clyde)
# end

# When /Clyde adds an erroneous person to the directory/ do
#   create_person(user: @clyde, attributes: { given_name: nil })
# end

# Then /the directory includes the person/ do
#   expect_person_to_exist
# end

# Then /the person is not accepted/ do
#   expect_person_to_be_refused
# end

# Then /Clyde can update the person/ do
#   update_person(user: @clyde)
# end
