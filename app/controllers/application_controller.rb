class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Override ApplicationController, where this default `helper_method` is defined.
  def patient_search
    @patient_search ||= begin
      Renalware::Patient.search(params[:q]).tap do |search|
        search.sorts = %w(family_name given_name)
      end
    end
  end
  helper_method :patient_search
end
