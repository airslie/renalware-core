FactoryBot.define do
  factory :drug_form, class: "Renalware::Drugs::Form" do
    sequence(:code) { "Code#{it}" }
  end
end
