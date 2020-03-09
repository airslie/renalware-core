# frozen_string_literal: true

# frozen_string_literal: true

require_dependency "renalware/medications"

module Renalware
  module Medications
    class Provider
      def self.codes
        %i(gp hospital home_delivery)
      end
    end
  end
end

# require_dependency "renalware/medications"

# module Renalware
#   module Medications
#     class Provider < ApplicationRecord
#       validates :name, presence: true
#       validates :code, presence: true
#       has_many :provider_drug_types, dependent: :restrict_with_exception
#       has_many :drug_types, through: :provider_drug_types

#       # TODOL:  read from db
#       def self.codes
#         %i(gp hospital home_delivery)
#       end
#     end
#   end
# end
