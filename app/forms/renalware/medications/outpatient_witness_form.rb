module Renalware
  module Medications
    class OutpatientWitnessForm
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :user_id, :integer
      attribute :password, :string
      attribute :outpatient_prescription_administration_id, :integer
      attribute :update_user_only, :boolean

      validates :user_id, presence: true
      validate :witness_is_not_the_administering_user

      with_options unless: :update_user_only do
        validates :password, presence: true
        validate :witness_password_is_valid
      end

      private

      def witness_is_not_the_administering_user
        if administration.administered_by_id == user_id
          errors.add(:user_id, "Cannot be the user who administered the prescription")
        end
      end

      def witness_password_is_valid
        unless witness.valid_password?(password)
          errors.add(:password, "Invalid password")
        end
      rescue Ldap::Error => e
        Rails.logger.error "LDAP error during witness password validation: #{e.message}"
        errors.add(:password, I18n.t("renalware.system.errors.ldap.service_unavailable"))
      end

      def witness = User.find(user_id)

      def administration
        OutpatientPrescriptionAdministration.find(outpatient_prescription_administration_id)
      end
    end
  end
end
