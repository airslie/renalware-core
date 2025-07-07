# frozen_string_literal: true

module Renalware
  class Events::Detail::Biopsy < Detail
    def view_template
      super do
        DetailItem(document, :result1, dig: :text)
        DetailItem(document, :result2, dig: :text)
        DetailItem(record, :notes)
      end
    end
  end
end
