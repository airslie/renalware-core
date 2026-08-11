module Renalware
  module Transplants
    class NHSBTWaitListUpload < ApplicationRecord
      include Accountable

      enum :status, {
        previewing: 0,
        imported: 1
      }

      validates :filename, presence: true
      validates :rows, presence: true
    end
  end
end
