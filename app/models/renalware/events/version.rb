# frozen_string_literal: true

require_dependency "renalware/events"

module Renalware
  module Events
    class Version < PaperTrail::Version
      self.table_name = :event_versions
    end
  end
end
