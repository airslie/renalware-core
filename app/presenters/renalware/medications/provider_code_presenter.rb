module Renalware
  module Medications
    class ProviderCodePresenter < DumbDelegator
      def to_s
        " " + ::I18n.t(super, scope: "enums.provider")
      end
    end
  end
end
