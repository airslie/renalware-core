# frozen_string_literal: true

module Renalware
  class Admin::PlaygroundsController < BaseController
    skip_after_action :verify_policy_scoped

    def show
      authorize User, :index?
      render locals: { form: nil }
    end
  end
end
