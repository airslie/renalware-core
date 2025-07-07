# frozen_string_literal: true

module Renalware
  class Events::Detail::ClinicalFrailtyScore < Detail
    def view_template
      super do
        DetailItem(document, :score, dig: :text)
        DetailItem(record, :notes)
      end
    end
  end
end
