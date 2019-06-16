# frozen_string_literal: true

module Renalware
  extend SeedsHelper

  log "Adding EQ5D Survey" do
    survey = Patients::Survey.create(name: "EQ5D-5L", description: "Patient health status")
    file_path = File.join(File.dirname(__FILE__), "eq5d_5l_questions.csv")
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
