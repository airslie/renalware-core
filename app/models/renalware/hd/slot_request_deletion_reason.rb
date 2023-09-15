# frozen_string_literal: true

module Renalware
  module HD
    class SlotRequestDeletionReason < ApplicationRecord
      acts_as_paranoid
      validates :reason, uniqueness: true
    end
  end
end
