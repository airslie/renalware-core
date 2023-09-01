# frozen_string_literal: true

module Renalware
  module Feeds
    class ReplayMessage < ApplicationRecord
      validates :replay_id, presence: true
      validates :message_id, presence: true
      belongs_to :replay
      belongs_to :message
    end
  end
end
