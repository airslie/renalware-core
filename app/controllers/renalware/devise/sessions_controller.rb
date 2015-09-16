module Renalware
  class Devise::SessionsController < ::Devise::SessionsController
    include Concerns::DeviseControllerMethods

    layout 'renalware/layouts/application'
  end
end