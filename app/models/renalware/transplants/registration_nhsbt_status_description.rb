module Renalware
  module Transplants
    class RegistrationNHSBTStatusDescription < ApplicationRecord
      validates :code, presence: true
      validates :name, presence: true

      def to_s = name
    end
  end
end
