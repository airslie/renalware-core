# frozen_string_literal: true

module Renalware
  class Events::Detail::Investigation < Detail
    def view_template
      super do
        DetailItem(document, :modality, dig: :text)
        DetailItem(document, :type, dig: :text)
        DetailItem(document, :result)
        DetailItem(record, :notes)
      end
    end
  end
end
