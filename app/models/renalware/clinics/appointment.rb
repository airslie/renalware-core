# frozen_string_literal: true

require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class Appointment < ApplicationRecord
      belongs_to :patient, touch: true
      belongs_to :clinic
      belongs_to :user

      validates :starts_at, presence: true
      validates :patient, presence: true
      validates :clinic, presence: true
      validates :user, presence: true

      validates :starts_at, timeliness: { type: :datetime }

      def starts_on
        starts_at.to_date
      end

      def start_time
        starts_at.strftime("%H:%M")
      end
    end
  end
end
