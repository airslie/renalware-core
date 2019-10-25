# frozen_string_literal: true

module Renalware
  module Patients
    # Experimental ActionView component
    class SideMenuComponent < ActionView::Component::Base
      validates :patient, presence: true

      def initialize(patient:)
        @patient = patient
      end

      private

      attr_reader :patient
    end
  end
end
