require_dependency "renalware/letters"

module Renalware
  module Letters
    class Recipient < ActiveRecord::Base
      belongs_to :letter
      belongs_to :source, polymorphic: true
      has_one :address, as: :addressable

      accepts_nested_attributes_for :address, reject_if: :address_not_needed?, allow_destroy: true

      def to_s
        name
      end

      def copy_address!(source_address)
        build_address if address.blank?
        address.copy_from(source_address).save!
      end

      private

      def address_not_needed?
        source_type.present?
      end
    end
  end
end
