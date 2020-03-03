# frozen_string_literal: true

module Renalware
  module HD
    class PrescriptionLastAdministrationComponent < ApplicationComponent
      attr_reader :prescription
      validates :prescription, presence: true

      def initialize(prescription:)
        @prescription = prescription
      end

      def last_administration
        @last_administration ||=
          PrescriptionLastAdministrationQuery.new(prescription: prescription).call
      end
    end
  end
end
