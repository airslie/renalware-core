# frozen_string_literal: true

require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class Clinic < ApplicationRecord
      include Accountable
      acts_as_paranoid

      has_many :clinic_visits, dependent: :restrict_with_exception
      has_many :appointments, dependent: :restrict_with_exception

      validates :name, presence: true, uniqueness: true
      validates :code, uniqueness: true

      scope :ordered, -> { order(deleted_at: :desc, name: :asc) }
      scope :with_last_clinic_visit_date, lambda {
        select(<<-SQL.squish)
          (SELECT max(clinic_visits.date)
          FROM clinic_visits
          WHERE clinic_visits.clinic_id=clinic_clinics.id) AS last_clinic_visit
        SQL
      }
      scope :with_last_appointment_time, lambda {
        select(<<-SQL.squish)
          (SELECT max(clinic_appointments.starts_at)
          FROM clinic_appointments
          WHERE clinic_appointments.clinic_id=clinic_clinics.id) AS last_clinic_appointment
        SQL
      }

      # Note sure if needed so commenting out
      # belongs_to :consultant, class_name: "Renalware::User", foreign_key: :user_id

      def to_s
        name
      end
    end
  end
end
