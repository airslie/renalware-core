require_dependency "renalware/medications"

module Renalware
  module Letters
    class Letter < DumbDelegator
      def recipient

      end

      def drug_types
        drug.drug_types.map(&:name).join(", ")
      end

      def provider
        ::I18n.t(super, scope: "enums.provider")
      end
    end
  end
end
