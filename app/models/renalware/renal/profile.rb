require_dependency "renalware/renal"
require "document/base"

module Renalware
  module Renal
    class Profile < ActiveRecord::Base
      include Document::Base
      extend Enumerize

      belongs_to :patient
      belongs_to :prd_description
      has_one :address_at_diagnosis, as: :addressable, class_name: "Address"

      has_document class_name: "Renalware::Renal::ProfileDocument"

      validates :patient, presence: true
      validates :esrf_on, timeliness: { type: :date, allow_nil: true }
      validates :first_seen_on, timeliness: { type: :date, allow_nil: true }
      validates :comorbidities_updated_on, timeliness: { type: :date, allow_nil: true }

      accepts_nested_attributes_for :address_at_diagnosis, reject_if: Address.reject_if_blank

      enumerize :smoking_status, in: %i(current ex_smoker nonsmoker unknown)

      def to_s
        [I18n.l(esrf_on), prd_description].compact.join(" ")
      end
    end
  end
end
