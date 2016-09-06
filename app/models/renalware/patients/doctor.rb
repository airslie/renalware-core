require_dependency "renalware/patients"

module Renalware
  module Patients
    class Doctor < ActiveRecord::Base
      include Personable
      include ActiveModel::Validations

      has_one :address, as: :addressable
      has_and_belongs_to_many :practices
      has_many :patients

      accepts_nested_attributes_for :address, reject_if: Address.reject_if_blank

      validates_with Doctors::AddressValidator
      validates_with Doctors::EmailValidator
      validates_uniqueness_of :code
      validates_presence_of :practitioner_type

      scope :ordered, -> { order(family_name: :asc) }

      def self.policy_class
        BasePolicy
      end

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
