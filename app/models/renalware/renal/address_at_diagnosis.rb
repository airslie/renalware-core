require_dependency "renalware/renal"

module Renalware
  module Renal
    class AddressAtDiagnosis < Address
      def to_partial_path
        "renalware/patients/address"
      end
    end
  end
end
