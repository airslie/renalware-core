module Renalware
  module Medications
    class RenewableHDPrescriptionsQuery
      include Callable

      pattr_initialize [:patient!]

      def call
        patient
          .prescriptions
          .current
          .ordered
          .includes([:trade_family, :unit_of_measure])
          .where(administer_on_hd: true)
          .where(fixed_number_of_doses: nil)
          .where(prescribed_on: ..(1.day.ago.end_of_day))
      end
    end
  end
end
