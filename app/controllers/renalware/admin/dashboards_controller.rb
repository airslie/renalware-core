# frozen_string_literal: true

module Renalware
  class Admin::DashboardsController < BaseController
    skip_after_action :verify_policy_scoped

    def show
      authorize User, :index?
    end
  end
end
