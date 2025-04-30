module Renalware::UserRoleSteps
  attr_reader :user

  step :create_clinician, ":name is a clinician"
  step :create_clinician, ":name is a doctor"
  step :login_user, ":name is logged in"
  step :change_date, "the date today is :date"

  def create_clinician(name)
    @user = FactoryBot.create(:user, :clinical, given_name: name)
  end

  def login_user(_user_name) =  login_as @user
  def change_date(date) =       travel_to date
end
