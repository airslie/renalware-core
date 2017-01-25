module Renalware
  module Clinics
    class ClinicVisit < ApplicationRecord
      include Accountable
      include PatientScope
      extend Enumerize

      belongs_to :patient
      belongs_to :clinic
      has_many :clinic_letters

      validates_presence_of :date
      validates_presence_of :clinic

      validates :date, timeliness: { type: :date }
      validates :time, timeliness: { type: :time, allow_blank: true }

      enumerize :urine_blood, in: %i(neg trace very_low low medium high)
      enumerize :urine_protein, in: %i(neg trace very_low low medium high)

      def bmi
        return unless weight && height && height > 0
        ((weight / height) / height).round(2)
      end

      def bp
        "#{systolic_bp}/#{diastolic_bp}" if systolic_bp.present? && diastolic_bp.present?
      end

      def bp=(val)
        self.systolic_bp, self.diastolic_bp = val.split("/")
      end
    end
  end
end
