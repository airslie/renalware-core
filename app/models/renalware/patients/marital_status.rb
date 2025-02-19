module Renalware
  module Patients
    class MaritalStatus < ApplicationRecord
      validates :code, presence: true, uniqueness: true
      validates :name, presence: true

      def to_s = name
    end
  end
end
