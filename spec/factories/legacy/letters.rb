# frozen_string_literal: true

FactoryBot.define do
  factory :legacy_letter, class: "Renalware::Legacy::Letter" do
    sequence(:legacy_id)
    patient
    letter_site { "BLT" }
    hospital_no { "H123" }
    authored_by factory: :user
    legacy_letter_author
    clinic_date { Date.current - 2.days }
    letter_date { Date.current - 1.day }
    letter_description { "Imported clinic letter" }
    recipient_name { "Dr Recipient" }
    letter_html { "<html><body><div id=\"letter_text_body\">Legacy body</div></body></html>" }
  end
end
