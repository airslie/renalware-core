require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class RegistrationStatusDescription < ActiveRecord::Base
      validates :name, presence: true
    end
  end
end
