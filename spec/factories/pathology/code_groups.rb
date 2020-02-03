# frozen_string_literal: true

FactoryBot.define do
  factory :pathology_code_group, class: "Renalware::Pathology::CodeGroup" do
    accountable
    name { "Group1" }
    description { "Group1Description" }

    trait :hd_session_form_recent do 
      name { "hd_session_form_recent" }
    end
  end
end
