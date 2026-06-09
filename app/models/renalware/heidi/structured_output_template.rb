module Renalware
  module Heidi
    class StructuredOutputTemplate
      MEDICATION_CHANGE_OPTIONS = [
        { value: "start", metadata: {} },
        { value: "stop", metadata: {} },
        { value: "dose_change", metadata: {} },
        { value: "frequency_change", metadata: {} },
        { value: "advice_only", metadata: {} }
      ].freeze

      def self.call
        {
          template: "Extract Renalware-importable clinical changes from this consultation.",
          questions: [new_problems_question, medication_changes_question],
          summaryRequired: true,
          metadata:
        }
      end

      def self.new_problems_question
        {
          questionId: "new_problems",
          question: "New or active problems mentioned in the consultation",
          description: "Only include diagnoses or problems explicitly supported by " \
                       "the consultation.",
          answerType: "TextArea",
          repeatable: true,
          childQuestions: [problem_onset_date_question, problem_snomed_question]
        }
      end

      def self.problem_onset_date_question
        {
          questionId: "problem_onset_date",
          question: "Problem onset or diagnosis date",
          description: "Only include if explicitly stated.",
          answerType: "DateResponse",
          dateFormat: "YYYY/MM/DD",
          repeatable: false,
          childQuestions: []
        }
      end

      def self.problem_snomed_question
        {
          questionId: "problem_snomed_code",
          question: "SNOMED CT code",
          description: "Only include if confidently identifiable from the consultation.",
          answerType: "TextArea",
          repeatable: false,
          childQuestions: []
        }
      end

      def self.medication_changes_question
        {
          questionId: "medication_changes",
          question: "Medication changes mentioned in the consultation",
          description: "Include starts, stops, dose changes, frequency changes, " \
                       "and medication advice.",
          answerType: "TextArea",
          repeatable: true,
          childQuestions: [medication_change_type_question]
        }
      end

      def self.medication_change_type_question
        {
          questionId: "medication_change_type",
          question: "Medication change type",
          description: "Classify the change if possible.",
          answerType: "SingleResponse",
          answerOptions: MEDICATION_CHANGE_OPTIONS,
          repeatable: false,
          childQuestions: []
        }
      end

      def self.metadata
        [
          "Only include information explicitly supported by the transcript or consult note.",
          "Do not invent diagnoses, medications, doses, dates, or codes.",
          "Return empty answers where no new information is present."
        ]
      end
    end
  end
end
