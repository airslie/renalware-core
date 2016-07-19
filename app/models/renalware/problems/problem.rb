require_dependency "renalware/problems"

module Renalware
  module Problems
    class Problem < ActiveRecord::Base
      include PatientScope

      acts_as_paranoid
      has_paper_trail class_name: "Renalware::Problems::Version"

      belongs_to :patient
      has_many :notes, dependent: :destroy

      scope :ordered, -> { order(position: :asc) }

      validates :patient, presence: true
      validates :description, presence: true

      def self.with_archived
        with_deleted
      end

      def self.current
        all
      end

      def self.archived
        only_deleted
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
        Proc.new { |attrs| attrs[:description].blank? }
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
