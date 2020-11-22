# frozen_string_literal: true

require_dependency "renalware/research"

module Renalware
  module Research
    class StudyParticipantsQuery
      pattr_initialize [:study!, :options!]

      def call
        search.result
      end

      def search
        study.participants.joins(:patient).eager_load(:patient).ransack(options)
      end
    end
  end
end
