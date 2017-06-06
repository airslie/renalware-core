require_dependency "renalware/pd"
require "document/base"

module Renalware
  module PD
    class TrainingSession < ApplicationRecord
      include Accountable
      include PatientScope
      include OrderedScope
      include Document::Base
      extend Enumerize

      belongs_to :patient, class_name: "Renalware::PD::Patient", touch: true

      attr_reader :ignore_me # see html form for explanation of this non-persistent attribute

      class Document < Document::Embedded
        attribute :started_on, Date
        attribute :trainer, String
        attribute :training_site, ::Document::Enum # Defined in i18n as may vary
        attribute :training_type, ::Document::Enum # Defined in i18n as may vary
        attribute :training_duration, String
        attribute :outcome, ::Document::Enum, enums: %i(successful limited_success unsuccessful)
        attribute :training_comments

        validates :started_on, presence: true
        validates :training_site, presence: true
        validates :training_type, presence: true

      end
      has_document
    end
  end
end
