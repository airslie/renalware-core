require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class DonorStageStatus < ApplicationRecord
      validates :name, presence: true, uniqueness: true
      validates :position, presence: true
    end
  end
end
