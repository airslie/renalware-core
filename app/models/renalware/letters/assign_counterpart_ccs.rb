require_dependency "renalware/letters"

# Method object to be initialized with an instance of Letter.
# It sets the proper "automatic" CCs based on the main recipient
# of the letter.
module Renalware
  module Letters
    class AssignCounterpartCCs < SimpleDelegator
      def call
        roles = []
        roles << "patient" if patient.cc_on_letter?(self)
        roles << "doctor" if patient.doctor.cc_on_letter?(self)

        apply(roles)
      end

      private

      def apply(roles)
        remove_futile_roles(roles)
        add_missing_roles(roles)
      end

      def remove_futile_roles(roles)
        allowed_roles = roles + ["other"]
        cc_recipients.each do |cc|
          delete_cc_if_not_in_roles(cc, allowed_roles)
        end
      end

      def delete_cc_if_not_in_roles(cc, roles)
        cc_recipients.delete(cc) unless roles.include?(cc.person_role)
      end

      def add_missing_roles(roles)
        existing_roles = cc_recipients.map(&:person_role)
        missing_roles = roles - existing_roles
        missing_roles.each do |role|
          cc_recipients.build(person_role: role)
        end
      end
    end
  end
end
