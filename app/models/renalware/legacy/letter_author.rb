# frozen_string_literal: true

module Renalware
  module Legacy
    class LetterAuthor < ApplicationRecord
      validates :name, presence: true
    end
  end
end
