# frozen_string_literal: true

require_dependency "renalware"

module Renalware
  module UKRDC
    class SurveyNotFoundError < StandardError; end

    class QuestionNotFoundError < StandardError; end

    def self.table_name_prefix
      "ukrdc_"
    end
  end
end
