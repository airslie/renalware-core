require_dependency "renalware/admissions"

module Renalware
  module Admissions
    class RequestReason < ApplicationRecord
      acts_as_paranoid
      validates :description, presence: true
    end
  end
end
