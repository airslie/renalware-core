FactoryGirl.define do
  factory :audit, class: "Renalware::Reporting::Audit" do
    name "Letters Authors"
    view_name "audit_letter_authors"
    refresh_schedule "1 0 * * *"
    display_configuration "{}"
  end
end
