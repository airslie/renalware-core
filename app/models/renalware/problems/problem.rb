# frozen_string_literal: true

require_dependency "renalware/problems"

module Renalware
  module Problems
    class Problem < ApplicationRecord
      include PatientScope
      include Accountable

      acts_as_paranoid
      has_paper_trail class_name: "Renalware::Problems::Version", on: [:create, :update, :destroy]

      belongs_to :patient, touch: true
      has_many :notes, dependent: :destroy

      scope :ordered, -> { order(position: :asc) }
      scope :with_notes, -> { includes(:notes) }
      scope :with_patient, ->{ includes(:patient) }

      validates :patient, presence: true
      validates :description, presence: true

      def self.with_archived
        with_deleted
      end

      def self.current
        all.with_notes
      end

      def self.archived
        only_deleted.with_notes
      end

      def archived?
        deleted?
      end

      def archived_at
        deleted_at
      end

      def archived_on
        deleted_at.to_date
      end

      def created_on
        created_at.to_date
      end

      def updated_on
        updated_at.to_date
      end

      def self.reject_if_proc
        proc { |attrs| attrs[:description].blank? }
      end

      def full_description
        description
      end

      def formatted
        "#{full_description}, #{date}"
      end
    end
  end
end
