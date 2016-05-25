require_dependency "renalware/letters"

# A method object initialized with an instance of Letter reponsible
# for determining the "counterpart CC's". A counterpart CC can be a patient,
# doctor or both.
#
module Renalware
  module Letters
    class DetermineCounterpartCCs < SimpleDelegator
      def call
        roles = []
        roles << "patient" if patient.cc_on_letter?(self)
        roles << "doctor" if patient.doctor.cc_on_letter?(self)

        apply(roles)
      end

      def call
        counterpart_css = []
        counterpart_css << build_recipient("patient") if patient.cc_on_letter?(self)
        counterpart_css << build_recipient("doctor") if patient.doctor.cc_on_letter?(self)
        counterpart_css
      end

      private

      def build_recipient(person_role)
        Recipient.new(person_role: person_role, letter: __getobj__)
      end
    end
  end
end
