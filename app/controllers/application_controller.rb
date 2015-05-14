class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_filter :prepare_patient_search

  private

  def prepare_patient_search
    @patient_search = Patient.ransack(params[:q])
  end
end
