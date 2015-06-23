module LoginMacros
  def login_as_admin
    login_user(:admin)
  end

  def login_as_clinician
    login_user(:clinician)
  end

  def login_as_read_only
    login_user(:read_only)
  end

  def login_user(role_trait=:super_admin)
    user = create(:user, :approved, role_trait)
    if @request.present? # eg for controller specs
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    else # features
      login_as user
    end
    user
  end

  alias_method :login_as_super_admin, :login_user
end
