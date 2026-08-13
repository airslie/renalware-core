module Renalware
  module Heidi
    class SessionContextBuilder
      def initialize(patient)
        @patient = patient
      end

      def call
        {
          patient: patient_payload,
          ehr_patient_id:
        }.tap do |context|
          context[:clinician_notes] = clinician_notes if clinician_notes.any?
        end
      end

      private

      attr_reader :patient

      def clinician_notes
        @clinician_notes ||= [
          problem_notes,
          prescription_notes
        ].flatten.compact
      end

      def patient_payload
        {
          name: patient.full_name,
          gender: heidi_gender(patient),
          dob: patient.born_on&.iso8601,
          demographic_details: patient_demographic_string
        }.compact_blank
      end

      def patient_demographic_string
        [patient.full_name, patient.sex&.to_s, patient.born_on&.iso8601].compact_blank.join(", ")
      end

      def ehr_patient_id
        patient.secure_id_dashed || patient.secure_id
      end

      def heidi_gender(patient)
        case patient.sex&.to_s
        when "M" then "MALE"
        when "F" then "FEMALE"
        else "OTHER"
        end
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
