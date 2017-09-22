FactoryGirl.define do
  factory :admissions_request, class: "Renalware::Admissions::Request" do
    association :reason, factory: :admissions_request_reason
    association :patient
    priority :low
  end
end
