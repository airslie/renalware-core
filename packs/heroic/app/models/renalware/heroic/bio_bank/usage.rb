# frozen_string_literal: true


module Renalware
  module Heroic
    module BioBank
      class Usage < ApplicationRecord
        include Accountable
        acts_as_paranoid
        has_paper_trail(
          versions: { class_name: "Renalware::Heroic::BioBank::Version" },
          on: [:create, :update, :destroy]
        )
        belongs_to :usable, polymorphic: true, counter_cache: :usable_count
        validates :used_at, presence: true
        validates :study_name, presence: true
      end
    end
  end
end
