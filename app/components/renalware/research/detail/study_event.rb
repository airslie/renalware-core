# frozen_string_literal: true

module Renalware
  class Research::Detail::StudyEvent < Detail
    def initialize(record)
      super(record:, fields: [])
    end

    def view_template
      super do
        if @layout&.definition.present?
          @layout.definition.each do |hash|
            attr = hash.keys.first
            label = hash.values.first["label"]
            DefinitionListItem(label, @document.send(attr.to_sym), title: label)
          end
        end

        DefinitionListItem("Notes", simple_format(event.notes))
      end
    end
  end
end
