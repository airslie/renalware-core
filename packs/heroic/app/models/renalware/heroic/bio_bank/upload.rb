# frozen_string_literal: true

module Renalware
  module Heroic
    module BioBank
      class Upload < ApplicationRecord
        include Accountable

        attr_accessor :tmp

        enum :status, [:previewing, :changes_committed, :error]
        enum :file_type, [:samples, :usage]
        has_one_attached :file
        has_many :samples, dependent: :nullify
        has_many :aliquots, dependent: :nullify
        has_many :usages, dependent: :nullify

        class AttachedValidator < ActiveModel::EachValidator
          def validate_each(record, attribute, value)
            record.errors.add(attribute, :attached, options) unless value.attached?
          end
        end

        validates :file, attached: true
      end
    end
  end
end
