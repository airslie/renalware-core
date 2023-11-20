# frozen_string_literal: true

require "duration_calculator"

module Renalware
  module HD
    class SessionPatientGroupDirection < ApplicationRecord
      belongs_to :session
      belongs_to :patient_group_direction, class_name: "Drugs::PatientGroupDirection"
      validates :session_id, presence: true
      validates :patient_group_direction_id, presence: true
    end
  end
end
