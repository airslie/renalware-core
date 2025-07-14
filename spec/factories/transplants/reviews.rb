FactoryBot.define do
  factory :transplant_review, class: "Renalware::Transplants::Review" do
    accountable
    patient
    event_type factory: :transplant_review_event_type
    date_time { Time.current }
  end
end
