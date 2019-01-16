# frozen_string_literal: true

require "rails_helper"

describe "Delayed Job management", type: :system do
  include RolesSpecHelper

  describe "Delayed Job dashboard" do
    it "is available for super_admin users" do
      login_user(:super_admin)
      visit delayed_job_path
      expect(page).to have_http_status(:ok)
    end

    it "is hidden for non-super-admin roles" do
      roles = define_roles - %i(super_admin devops)
      roles.each do |role|
        login_user(role)
        expect{ visit delayed_job_path }.to raise_error(ActionController::RoutingError)
      end
    end
  end
end
