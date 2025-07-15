# frozen_string_literal: true

module Renalware
  class Clinics::TimelineRow < TimelineRow
    private

    def row_toggler
      dietetics? ? super : TableCell()
    end

    def description
      TableCell { @record.clinic.name }
    end

    def type
      TableCell do
        dietetics? ? "Dietetic Clinic Visit" : "Clinic Visit"
      end
    end

    def detail
      return "" unless dietetics?

      TableDetailRow(COLUMNS) do
        render partial("/renalware/dietetics/clinic_visits/summary", clinic_visit: @record)
      end
    end

    def dietetics?
      @record.is_a?(Dietetics::ClinicVisit)
    end
  end
end
