# frozen_string_literal: true

module Renalware
  class Research::StudyEventDetail < Detail
    include ActionView::Helpers::TextHelper

    def view_template
      super do
        event_subtype = Renalware::Events::Subtype.with_deleted.find_by(id: record.subtype_id)

        if event_subtype&.definition.present?
          event_subtype.definition.each do |hash|
            attr = hash.keys.first
            label = hash.values.first["label"]
            DescriptionListItem(label, document.send(attr.to_sym), title: label)
          end
        end

        DescriptionListItem("Notes", simple_format(record.notes))
      end
    end
  end
end
