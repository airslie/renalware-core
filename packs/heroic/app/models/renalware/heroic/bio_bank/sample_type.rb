# frozen_string_literal: true

module Renalware
  module Heroic
    module BioBank
      class SampleType < ApplicationRecord
        validates :name, presence: true
        validates :abbreviation, presence: true
      end
    end
  end
end
