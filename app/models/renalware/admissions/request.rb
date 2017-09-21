require_dependency "renalware/admissions"

module Renalware
  module Admissions
    class Request < ApplicationRecord
      include Accountable
      acts_as_paranoid

      belongs_to :patient
      belongs_to :reason, class_name: "RequestReason"
      validates :patient_id, presence: true, uniqueness: true
      validates :reason_id, presence: true

      scope :ordered, ->{ order(position: :asc) }
    end
  end
end
