# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Surveys
    describe Question do
      it_behaves_like "a Paranoid model"
      it :aggregate_failures do
        is_expected.to belong_to :survey
        is_expected.to have_many :responses
        is_expected.to validate_presence_of :code
        is_expected.to validate_presence_of :label
        is_expected.to validate_presence_of :position
      end

      describe "uniqueness scoped to survey" do
        subject { Question.new(code: "x", survey: survey) }

        let(:survey) { Survey.create(name: "Survey1", code: "x") }

        it { is_expected.to validate_uniqueness_of(:code).scoped_to(:survey_id) }
      end
    end
  end
end
