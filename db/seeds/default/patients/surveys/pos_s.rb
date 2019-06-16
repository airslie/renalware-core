# frozen_string_literal: true

module Renalware
  extend SeedsHelper

  log "Adding POS-S Renal Survey" do
    survey = Patients::Survey.create(name: "POS-S", description: "Patient health status")
    file_path = File.join(File.dirname(__FILE__), "pos_s_questions.csv")
    questions = []

    CSV.foreach(file_path, headers: true) do |row|
      questions << Patients::SurveyQuestion.new(
        survey: survey,
        code: row["code"],
        position: row["position"],
        label: row["label"],
        validation_regex: row["validation_regex"]
      )
    end
    Patients::SurveyQuestion.import! questions
  end
end
