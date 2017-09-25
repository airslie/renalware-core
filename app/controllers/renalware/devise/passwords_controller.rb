class Renalware::Devise::PasswordsController < ::Devise::PasswordsController
  helper Renalware::ApplicationHelper
  include Renalware::Concerns::DeviseControllerMethods

  layout "renalware/layouts/application"
end
