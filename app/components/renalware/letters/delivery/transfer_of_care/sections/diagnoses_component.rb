# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare::Sections
    class DiagnosesComponent < SectionComponent
      def problems
        @problems ||= CollectionPresenter.new(patient.problems, Problems::ProblemPresenter)
      end
    end
  end
end
