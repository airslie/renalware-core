# frozen_string_literal: true

module Renalware
  class Events::Detail::Simple < Detail
    def view_template
      super do
        DetailItem(record, :description)
        DetailItem(record, :notes)
      end
    end
  end
end
