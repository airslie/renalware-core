FactoryBot.define do
  factory :language, class: "Renalware::Patients::Language" do
    name "English"
    code "en"

    trait :english do
      name "English"
      code "en"
    end

    trait :aftrikaans do
      name "Afrikaans"
      code "af"
    end
  end
end
