require_dependency "renalware/problems"

module Renalware
  module Problems
    class Problem < ActiveRecord::Base
      include PatientScope

      acts_as_paranoid
      has_paper_trail class_name: "Renalware::Problems::Version"

      belongs_to :patient
      has_many :notes, dependent: :destroy

      validates :patient, presence: true
      validates :description, presence: true

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
