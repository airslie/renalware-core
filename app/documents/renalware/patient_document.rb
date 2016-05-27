require "document/embedded"
require "document/enum"

module Renalware
  class PatientDocument < Document::Embedded
    attribute :interpreter_notes, String
    attribute :admin_notes, String
    attribute :special_needs_notes, String
  end
end
