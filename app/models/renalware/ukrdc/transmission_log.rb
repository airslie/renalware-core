require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    class TransmissionLog < ApplicationRecord
      validates :sent_at, presence: true
      belongs_to :patient, class_name: "Renalware::Patient"
    end
  end
end
