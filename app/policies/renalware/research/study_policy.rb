# frozen_string_literal: true

require_dependency "renalware/research"

module Renalware
  module Research
    class StudyPolicy < ResearchPolicy
      alias study record
    end
  end
end
