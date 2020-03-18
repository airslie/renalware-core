# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    module Mailshots
      class Mailshot < ApplicationRecord
        include Accountable

        belongs_to :author, class_name: "User"
        belongs_to :letterhead
        has_many :items, dependent: :destroy
        has_many :letters, through: :items

        validates :description, presence: true
        validates :sql_view_name, presence: true
        validates :body, presence: true
        validates :author, presence: true
        validates :letterhead, presence: true

        # The sql view should ideally only have one column - 'patient_id' because we use this
        # to filter the patients we want.
        def recipient_patients
          @recipient_patients ||= begin
            return Patient.none if sql_view_name.blank?

            Patient.where(Arel.sql("id in (select distinct patient_id from #{sql_view_name})"))
          end
        end
      end
    end
  end
end
