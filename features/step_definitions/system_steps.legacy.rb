Given(/^that I'm logged in$/) do
  @user ||= FactoryGirl.create(:user, :approved, :super_admin)
  login_as @user
end
