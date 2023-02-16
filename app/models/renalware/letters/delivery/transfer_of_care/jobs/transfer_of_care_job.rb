# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare
    class Jobs::TransferOfCareJob < ApplicationJob
      queue_as :transfer_of_care
      queue_with_priority 10
    end
  end
end
