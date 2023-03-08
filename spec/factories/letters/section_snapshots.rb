# frozen_string_literal: true

FactoryBot.define do
  factory :section_snapshot, class: "Renalware::Letters::SectionSnapshot" do
    letter { nil }
  end
end
