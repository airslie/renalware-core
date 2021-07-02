# frozen_string_literal: true

module Renalware
  class Admin::PlaygroundsController < BaseController
    def show
      authorize User, :index?
      render locals: { form: nil }
    end
  end
end
