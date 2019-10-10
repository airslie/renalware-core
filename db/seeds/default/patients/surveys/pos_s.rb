# frozen_string_literal: true

module Renalware
  log "Adding POS-S Renal Survey" do
    survey = Surveys::Survey.create(name: "PROM", code: "prom", description: "Patient health status")
    file_path = File.join(File.dirname(__FILE__), "pos_s_questions.csv")
    questions = []

    CSV.foreach(file_path, headers: true) do |row|
      questions << Surveys::Question.new(
        survey: survey,
        code: row["code"],
        position: row["position"],
        label: row["label"],
        validation_regex: row["validation_regex"]
      )
    end
    Surveys::Question.import! questions
  end
end
