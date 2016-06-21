module Renalware
  module Clinics
    class ClinicVisit < ActiveRecord::Base
      include Accountable
      include PatientScope

      belongs_to :patient
      belongs_to :clinic
      has_many :clinic_letters

      validates_presence_of :date
      validates_presence_of :clinic

      validates :date, timeliness: { type: :date }

      def bmi
        ((weight / height) / height).round(2)
      end

      def bp
        "#{systolic_bp}/#{diastolic_bp}" if systolic_bp.present? && diastolic_bp.present?
      end

      def bp=(val)
        self.systolic_bp, self.diastolic_bp = val.split("/")
      end

      def to_s
        "Clinic Visit"
      end
    end
  end
end
