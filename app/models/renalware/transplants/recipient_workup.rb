require_dependency "renalware/transplants"
require "document/base"

module Renalware
  module Transplants
    class RecipientWorkup < ApplicationRecord
      include Document::Base
      include PatientScope
      include Accountable

      belongs_to :patient, touch: true

      has_paper_trail class_name: "Renalware::Transplants::Version"
      has_document class_name: "Renalware::Transplants::RecipientWorkupDocument"
    end
  end
end
