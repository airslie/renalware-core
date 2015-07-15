class ApplicationController < ActionController::Base
  include CancanControllerMethods
  include DeviseControllerMethods

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :prepare_patient_search

  private

  def prepare_patient_search
    @patient_search = Patient.ransack(params[:q])
    @patient_search.sorts = ['surname', 'forename']
  end

  def regime_type_params(regime)
    regime.underscore.to_sym
  end
end
