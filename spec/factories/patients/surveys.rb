# frozen_string_literal: true

FactoryBot.define do
  factory :survey, class: "Renalware::Patients::Survey" do
    name { "name" }
    description { "description" }

    factory :eq5d_survey do
      name { "EQ5D" }
      description { "Patient health status" }
    end

    factory :pos_s_survey do
      name { "PROM" }
      description { "Patient health status" }
    end
  end

  factory :survey_question, class: "Renalware::Patients::SurveyQuestion" do
    label { "label" }
  end
end
