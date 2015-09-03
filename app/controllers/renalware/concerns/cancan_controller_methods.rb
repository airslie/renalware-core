require 'active_support/concern'

module Renalware
  module Concerns::CancanControllerMethods
    extend ActiveSupport::Concern

    included do
      class_eval do
        rescue_from CanCan::AccessDenied do |exception|
          redirect_to root_url, :alert => exception.message
        end
      end
    end
  end
end