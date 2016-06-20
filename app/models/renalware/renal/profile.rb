require_dependency "renalware/renal"

module Renalware
  module Renal
    class Profile < ActiveRecord::Base
      belongs_to :patient
      belongs_to :prd_description
      has_one :address_at_diagnosis, as: :addressable, class_name: "Address"

      validates :patient, presence: true
      validates :esrf_on, timeliness: { type: :date, allow_nil: true }
      validates :first_seen_on, timeliness: { type: :date, allow_nil: true }

      accepts_nested_attributes_for :address_at_diagnosis, reject_if: Address.reject_if_blank

      def to_s
        [I18n.l(esrf_on), prd_description].compact.join(" ")
      end
    end
  end
end
