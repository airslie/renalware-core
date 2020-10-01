# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    class Description < ApplicationRecord
      validates :text, presence: true

      has_many :letters, dependent: :restrict_with_exception

      scope :ordered, -> { order(position: :asc, text: :asc) }
    end
  end
end
