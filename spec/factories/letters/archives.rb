# frozen_string_literal: true

FactoryBot.define do
  factory :letter_archive, class: "Renalware::Letters::Archive" do
    content ":html-content:"
  end
end
