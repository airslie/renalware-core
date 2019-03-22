# frozen_string_literal: true

require_dependency "renalware/feeds"

module Renalware
  module Feeds
    # Test messages stored in the databse that we can run to check they work
    class HL7TestMessage < ApplicationRecord
    end
  end
end
