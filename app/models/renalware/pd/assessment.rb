require_dependency "renalware/pd"
require "document/base"

module Renalware
  module PD
    class Assessment < ApplicationRecord
      include Accountable
      include PatientScope
      include OrderedScope
      include Document::Base
      extend Enumerize

      belongs_to :patient, class_name: "Renalware::Patient", touch: true

      attr_reader :ignore_me

      class Document < Document::Embedded
        attribute :had_home_visit, ::Document::Enum, enums: %i(yes no)
        attribute :home_visit_on, Date
        attribute :housing_type, ::Document::Enum, enums: %i(patient council)
        attribute :occupant_notes, String
        attribute :exchange_area, String
        attribute :handwashing, String
        attribute :fluid_storage, String
        attribute :bag_warming, String
        attribute :delivery_frequency, String
      end
      has_document

    end
  end
end
