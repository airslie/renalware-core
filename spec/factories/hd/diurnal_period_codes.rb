FactoryGirl.define do
  factory :hd_diurnal_period_code, class: "Renalware::HD::DiurnalPeriodCode" do
    initialize_with { Renalware::HD::DiurnalPeriodCode.find_or_create_by(code: code) }
    trait :am { code "am" }
    trait :pm { code "pm" }
    trait :eve { code "eve" }
  end
end
