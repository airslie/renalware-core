# frozen_string_literal: true

require_dependency "renalware/pd"

module Renalware
  module PD
    class AdequacyResult < ApplicationRecord
      include PatientScope
      include Accountable
      acts_as_paranoid

      belongs_to :patient, class_name: "Renalware::PD::Patient", touch: true
      scope :ordered, -> { order(created_at: :desc) }
      validates :performed_on, presence: true
    end
  end
end
