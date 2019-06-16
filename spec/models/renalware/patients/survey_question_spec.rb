# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Patients
    describe SurveyQuestion do
      it_behaves_like "a Paranoid model"
      it { is_expected.to belong_to :survey }
      it { is_expected.to have_many :responses }
      it { is_expected.to validate_presence_of :code }
      it { is_expected.to validate_presence_of :label }
      it { is_expected.to validate_presence_of :position }

      describe "uniqueness scoped to survey" do
        subject { SurveyQuestion.new(code: "x", survey: survey) }

        let(:survey) { Survey.create(name: "Survey1") }

        it { is_expected.to validate_uniqueness_of(:code).scoped_to(:survey_id) }
      end
    end
  end
end
