module Renalware
  module Heidi
    class SessionContextBuilder
      def initialize(patient)
        @patient = patient
      end

      def call
        return {} if clinician_notes.none?

        { clinician_notes: }
      end

      private

      attr_reader :patient

      def clinician_notes
        @clinician_notes ||= [
          problem_notes,
          prescription_notes
        ].flatten.compact
      end

      def problem_notes
        return if problem_lines.none?

        ["Renalware patient problems:", *problem_lines]
      end

      def problem_lines
        @problem_lines ||= patient.problems.current.map do |problem|
          problem_line(problem)
        end
      end

      def problem_line(problem)
        [
          "- #{problem.description}",
          context_part("SNOMED", problem.snomed_id),
          context_part("Date", problem.date&.iso8601)
        ].compact_blank.join("; ")
      end

      def context_part(label, value)
        "#{label}: #{value}" if value.present?
      end

      def prescription_notes
        return if prescription_lines.none?

        ["Renalware current prescriptions:", *prescription_lines]
      end

      def prescription_lines
        @prescription_lines ||= current_prescriptions.map do |prescription|
          "- #{Renalware::Medications::PrescriptionPresenter.new(prescription)}"
        end
      end

      def current_prescriptions
        @current_prescriptions ||= patient
          .prescriptions
          .current
          .with_drugs
          .with_medication_route
          .with_units_of_measure
          .ordered
      end
    end
  end
end
