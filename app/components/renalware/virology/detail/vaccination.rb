# frozen_string_literal: true

module Renalware
  class Virology::Detail::Vaccination < Detail
    def view_template
      super do
        DetailItem(document, :type_name, label: :type)
        DetailItem(document, :drug)
        DetailItem(record, :notes)
      end
    end
  end
end
