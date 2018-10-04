# frozen_string_literal: true

require_dependency "renalware/low_clearance"
require "document/base"

module Renalware
  module LowClearance
    class Profile < ApplicationRecord
      include Accountable
      include Document::Base
      validates :patient, presence: true
      belongs_to :patient, touch: true
      has_document class_name: "Renalware::LowClearance::ProfileDocument"
      has_paper_trail class_name: "Renalware::LowClearance::Version",
                      on: [:create, :update, :destroy]
    end
  end
end
