# frozen_string_literal: true

module Renalware
  class Messaging::Internal::TimelineRow < TimelineRow
    private

    def type = TableCell { "Message" }
    def description = TableCell { @record.subject }
    def created_by = TableCell { @record.author.full_name }
    def detail = TableDetailRow(COLUMNS) { @record.body }
  end
end
