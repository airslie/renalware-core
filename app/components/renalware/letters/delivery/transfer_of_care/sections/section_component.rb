# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare::Sections
    class SectionComponent < ApplicationComponent
      pattr_initialize :letter
      delegate :patient, to: :letter, allow_nil: true
    end
  end
end
