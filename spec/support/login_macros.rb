module LoginMacros
  def login_admin
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in FactoryGirl.create(:admin) # Using factory girl as an example
  end

  def login_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = create(:user, :approved)
    sign_in user
  end
end
