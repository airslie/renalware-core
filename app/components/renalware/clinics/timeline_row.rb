# frozen_string_literal: true

module Renalware
  class Clinics::TimelineRow < TimelineRow
    private

    def row_toggler = TableCell()
    def type = TableCell { "Clinic Visit" }
    def description = TableCell { @record.clinic.name }
  end
end
