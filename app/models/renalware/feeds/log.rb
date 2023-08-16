# frozen_string_literal: true

module Renalware
  module Feeds
    class Log < ApplicationRecord
      belongs_to :message
      belongs_to :patient
      validates :log_type, presence: true
      validates :log_reason, presence: true

      enum log_type: {
        close_match: "close_match"
      }

      enum log_reason: {
        number_hit_dob_miss: "number_hit_dob_miss"
      }
    end
  end
end
