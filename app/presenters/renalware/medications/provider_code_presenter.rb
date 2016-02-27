module Renalware
  module Medications
    class ProviderCodePresenter < DumbDelegator
      def to_label
        " " + ::I18n.t(to_s, scope: "enums.provider")
      end
    end
  end
end
