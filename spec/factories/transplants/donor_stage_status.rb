# frozen_string_literal: true

FactoryBot.define do
  factory :donor_stage_status, class: "Renalware::Transplants::DonorStageStatus" do
    name { Faker::Lorem.word }
  end
end
