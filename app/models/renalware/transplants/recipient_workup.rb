# frozen_string_literal: true

require_dependency "renalware/transplants"
require "document/base"

module Renalware
  module Transplants
    class RecipientWorkup < ApplicationRecord
      include Document::Base
      include PatientScope
      include Accountable

      belongs_to :patient, touch: true

      has_paper_trail class_name: "Renalware::Transplants::Version",
                      on: [:create, :update, :destroy]
      has_document class_name: "Renalware::Transplants::RecipientWorkupDocument"
    end
  end
end
