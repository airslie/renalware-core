# frozen_string_literal: true

FactoryBot.define do
  factory :donor_stage_position, class: "Renalware::Transplants::DonorStagePosition" do
    name { Faker::Lorem.word }
  end
end
