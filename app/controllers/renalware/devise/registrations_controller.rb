class Renalware::Devise::RegistrationsController < ::Devise::RegistrationsController
  include Renalware::Concerns::DeviseControllerMethods

  layout 'renalware/layouts/application'
end
