# frozen_string_literal: true

FactoryBot.define do
  factory :access_profile, class: "Renalware::Accesses::Profile" do
    accountable
    patient
    type { create(:access_type) }
    side { :right }
    formed_on { Time.zone.today }
    started_on { Time.zone.today }

    trait :current do
      started_on { 1.day.ago }
    end
  end
end
