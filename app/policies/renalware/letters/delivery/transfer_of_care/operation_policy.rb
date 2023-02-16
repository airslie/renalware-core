# frozen_string_literal: true

module Renalware
  module Letters
    module Delivery
      module TransferOfCare
        class OperationPolicy < BasePolicy
          alias check_inbox? create?
          alias handshake? create?
        end
      end
    end
  end
end
