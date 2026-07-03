# frozen_string_literal: true

module Renalware
  module Legacy
    class Letter < ApplicationRecord
      include Renalware::RansackAll

      belongs_to :patient, class_name: "Renalware::Patient"
      belongs_to :authored_by, class_name: "Renalware::User", optional: true
      belongs_to :legacy_letter_author,
                 class_name: "Renalware::Legacy::LetterAuthor",
                 optional: true

      validates :legacy_id, presence: true
      validates :patient_id, presence: true

      scope :ordered, -> { order(letter_date: :desc) }
      scope :for_patient, ->(patient) { where(patient:) }

      def self.policy_class = Renalware::Legacy::LetterPolicy

      def letter_body_text
        return if letter_html.blank?

        html = Nokogiri::HTML(letter_html)
        body_selectors
          .filter_map { |selector| html.css(selector).map(&:to_html).first }
          .first || letter_html
      end

      private

      def body_selectors
        selectors = Renalware.config.legacy_letters_body_selector.to_s.split(",").map(&:strip)
        (selectors + ["#letter_text_body"]).compact_blank.uniq
      end
    end
  end
end
