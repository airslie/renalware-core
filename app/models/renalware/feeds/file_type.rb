# frozen_string_literal: true

require_dependency "renalware/feeds"

module Renalware
  module Feeds
    class FileType < ApplicationRecord
      validates :name, presence: true
      validates :description, presence: true
      validates :prompt, presence: true

      has_many :files, dependent: :destroy
    end
  end
end
