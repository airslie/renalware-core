class Renalware::Devise::RegistrationsController < ::Devise::RegistrationsController
  helper Renalware::ApplicationHelper
  include Renalware::Concerns::DeviseControllerMethods

  layout "renalware/layouts/application"
end
