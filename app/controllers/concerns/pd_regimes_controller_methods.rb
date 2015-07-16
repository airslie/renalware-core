require 'active_support/concern'

module PdRegimesControllerMethods
  extend ActiveSupport::Concern

  included do

    def regime_type_params(regime)
      regime.underscore.to_sym
    end

  end
end
