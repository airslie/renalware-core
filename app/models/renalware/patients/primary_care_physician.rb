require_dependency "renalware/patients"

module Renalware
  module Patients
    # Represents a Primary Care Physician (PCP). The PCP could either be:
    # - a UK-based General Practitioner (GP)
    # - a foreign PCP or other referring physician
    #
    class PrimaryCarePhysician < ApplicationRecord
      include Personable
      include ActiveModel::Validations

      has_one :address, as: :addressable
      has_and_belongs_to_many :practices
      has_many :patients

      accepts_nested_attributes_for :address, reject_if: Address.reject_if_blank

      validates_with PrimaryCarePhysicians::AddressValidator
      validates_with PrimaryCarePhysicians::EmailValidator
      validates :email, email: true, allow_blank: true
      validates_uniqueness_of :code
      validates_presence_of :practitioner_type

      scope :ordered, -> { order(family_name: :asc) }

      def title
        "Dr"
      end

      def current_address
        address || practice_address
      end

      def practice_address
        address = practices.first.try(:address)
        address.name = "#{title} #{full_name}" if address.present?
        address
      end
    end
  end
end
