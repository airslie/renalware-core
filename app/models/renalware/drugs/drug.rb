# frozen_string_literal: true

module Renalware
  module Drugs
    class Drug < ApplicationRecord
      acts_as_paranoid

      has_many :classifications, dependent: :destroy
      has_many :drug_types, through: :classifications, after_remove: proc { |drug| drug.touch }

      scope :ordered, -> { order(:name) }

      validates :name, presence: true

      has_paper_trail(
        versions: { class_name: "Renalware::Drugs::Version" },
        on: [:create, :update, :destroy]
      )

      def self.for(code)
        joins(:drug_types).where(drug_types: { code: code.to_s })
      end

      def display_type
        "Standard Drug"
      end

      def to_s
        name
      end
    end
  end
end
