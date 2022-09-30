# frozen_string_literal: true

module Renalware
  module Letters
    class Description < ApplicationRecord
      include Sortable
      acts_as_paranoid
      validates :text, presence: true, uniqueness: true

      scope :ordered, -> { order(deleted_at: :desc, position: :asc, text: :asc) }
    end
  end
end
