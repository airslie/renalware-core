# frozen_string_literal: true


module Renalware
  module Heroic
    module BioBank
      class Sample < ApplicationRecord
        include Accountable
        extend Enumerize
        acts_as_paranoid
        has_paper_trail(
          versions: { class_name: "Renalware::Heroic::BioBank::Version" },
          on: [:create, :update, :destroy]
        )
        has_many :aliquots, dependent: :destroy
        belongs_to :patient
        belongs_to :sample_type

        validates :patient, presence: true
        validates :sample_type, presence: true
      end
    end
  end
end
