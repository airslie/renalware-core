# frozen_string_literal: true

FactoryBot.define do
  factory :view_metadata, class: "Renalware::System::ViewMetadata" do
    schema_name { "renalware" }
    view_name { "transplant_mdm_patients" }
    title { "Title" }
    slug { "all" }
    category { "mdm" }
    scope { "transplant" }
    columns { [] }
    filters { { sex: :list, age: :search } }
    position { 1 }
  end
end
