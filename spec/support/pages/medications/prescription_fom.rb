# frozen_string_literal: true

require_relative "../page_object"

module Pages
  module Medications
    # Wraps the Add Prescription form
    class PrescriptionForm < PageObject
      def drug_type=(value)
        select value, from: "Medication Type"
      end

      def drug=(value)
        select value, from: "Drug"
      end

      def drug_dose=(value)
        fill_in "Dose amount", with: value
      end

      def dose_unit=(value)
        select value, from: "Dose unit"
      end

      def route=(value)
        select value, from: "Route"
      end

      def route_description=(value)
        fill_in "Route description", with: value
      end

      def frequency=(value)
        fill_in "Frequency & Duration", with: value
      end

      def prescribed_on=(value)
        fill_in "Prescribed on", with: value
      end

      def last_delivery_date=(date)
        fill_in "Last delivery date", with: date
      end

      def next_delivery_date=(date)
        fill_in "Next delivery date", with: date
      end

      def provider=(value)
        within(".medications_prescription_provider") do
          choose value
        end
      end

      def save
        within ".actions" do
          click_on "Save"
        end
      end
    end
  end
end
