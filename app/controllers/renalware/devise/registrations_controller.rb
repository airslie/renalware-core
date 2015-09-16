module Renalware
  class Devise::RegistrationsController < ::Devise::RegistrationsController
    include Concerns::DeviseControllerMethods

    layout 'renalware/layouts/application'
  end
end