# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    class WorryCategory < ApplicationRecord
      include Accountable
      acts_as_paranoid
      validates :name, presence: true, uniqueness: true
    end
  end
end
