# frozen_string_literal: true

module Renalware
  module Heroic
    module Research
      class Investigatorship < Renalware::Research::Investigatorship
        class Document < Heroic::Document
          # The roles here are just a means of capturing attributes of the user to be used in
          # reporting (the 'delegation log') and do not drive functionality elsewhere in that way
          # that Renalware::User#role does for example.
          attribute :roles, ::Document::Enum, enumerize: { multiple: true }

          attribute :other_duties, String
        end
        has_document
      end
    end
  end
end
