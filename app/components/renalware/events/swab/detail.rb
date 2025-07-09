# frozen_string_literal: true

module Renalware
  class Events::Swab::Detail < Detail
    def view_template
      super do
        DetailItem(document, :location)
        DetailItem(record, :notes)
      end
    end
  end
end
