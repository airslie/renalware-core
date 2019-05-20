# frozen_string_literal: true

require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    class Treatment < ApplicationRecord
      belongs_to :patient
      belongs_to :clinician, class_name: "Renalware::User"
      belongs_to :modality_code
      validates :patient, presence: true
      validates :modality_code, presence: true

      scope :ordered, -> { order(started_on: :asc, ended_on: :asc) }
    end
  end
end
