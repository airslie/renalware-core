require_dependency "renalware/admissions"

module Renalware
  module Admissions
    class Request < ApplicationRecord
      include Accountable
      acts_as_paranoid

      belongs_to :patient
      belongs_to :reason, class_name: "RequestReason"
      validates :patient, presence: true
      validates :reason, presence: true
      validates :created_by, presence: true
      validates :updated_by, presence: true
    end
  end
end
