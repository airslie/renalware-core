# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    class AbridgementSearchForm
      include ActiveModel::Model
      attr_accessor :criteria
    end
  end
end
