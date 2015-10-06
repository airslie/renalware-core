require 'extensions/pundit'

module Renalware
  class BaseController < ActionController::Base
    include Concerns::DeviseControllerMethods
    include Pundit

    after_action :verify_authorized

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    layout 'renalware/layouts/application'

    before_filter :prepare_patient_search

    private

    def prepare_patient_search
      @patient_search = Renalware::Patient.ransack(params[:q])
      @patient_search.sorts = ['surname', 'forename']
    end

    def load_patient
      @patient = Patient.find(params[:patient_id])
    end

    def current_ability
      @current_ability ||= Renalware::Ability.new(current_user)
    end

    def user_not_authorized
      flash[:error] = "You are not authorized to perform this action."
      redirect_to patients_path
    end
  end
end
