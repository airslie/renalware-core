# frozen_string_literal: true

module Renalware
  module Letters
    class Topic < ApplicationRecord
      # TODO: Rename table to `letter_topics`
      self.table_name = "letter_descriptions"

      include Sortable
      acts_as_paranoid
      validates :text, presence: true, uniqueness: true

      scope :ordered, -> { order(deleted_at: :desc, position: :asc, text: :asc) }
    end
  end
end
