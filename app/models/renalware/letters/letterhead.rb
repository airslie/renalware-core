# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    class Letterhead < ApplicationRecord
      validates :name, presence: true
      validates :unit_info, presence: true
      validates :trust_name, presence: true
      validates :trust_caption, presence: true

      scope :ordered, -> { order(name: :asc) }
    end
  end
end
