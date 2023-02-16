# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters::Delivery::TransferOfCare
  describe Jobs::EndpointlookupJob do
    pending "test when ods code not found"
    pending "test when ods code has > 1 address in results"
    pending "test happy path mailbox found, updates practice with maiolboxid and description"
  end
end
