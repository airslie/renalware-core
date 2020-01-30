# frozen_string_literal: true

module Renalware
  class Admin::DashboardsController < BaseController
    def show
      authorize User, :index?
    end
  end
end
