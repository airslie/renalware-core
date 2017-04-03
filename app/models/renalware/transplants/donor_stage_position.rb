require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class DonorStagePosition < ApplicationRecord
      validates :name, presence: true, uniqueness: true
      validates :position, presence: true
    end
  end
end
