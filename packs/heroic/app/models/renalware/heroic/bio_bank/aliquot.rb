# frozen_string_literal: true


module Renalware
  module Heroic
    module BioBank
      class Aliquot < ApplicationRecord
        include Accountable
        acts_as_paranoid
        has_paper_trail(
          versions: { class_name: "Renalware::Heroic::BioBank::Version" },
          on: [:create, :update, :destroy]
        )
        belongs_to :sample, counter_cache: true
        validates :sample, presence: true
        has_one :usage, as: :usable, dependent: :destroy

        def used?
          usage.present?
        end
      end
    end
  end
end
