# frozen_string_literal: true

require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class Consultant < ApplicationRecord
      include Accountable
      acts_as_paranoid

      validates :name, presence: true, uniqueness: true
      validates :code, presence: true, uniqueness: true

      scope :ordered, -> { order(deleted_at: :desc, name: :asc) }
      scope :with_appointment_fields, lambda {
        select("clinic_consultants.*")
        .select(<<-SQL.squish)
          (
            SELECT max(clinic_appointments.starts_at)
            FROM clinic_appointments
            WHERE clinic_appointments.consultant_id = clinic_consultants.id
          ) AS last_clinic_appointment
        SQL
        .select(<<-SQL.squish)
          (
            SELECT count(clinic_appointments.id)
            FROM clinic_appointments
            WHERE clinic_appointments.consultant_id = clinic_consultants.id
          ) AS appointments_count
        SQL
      }

      def to_s
        name
      end
    end
  end
end
