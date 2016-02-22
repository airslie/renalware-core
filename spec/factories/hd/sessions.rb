FactoryGirl.define do
  factory :hd_session, class: "Renalware::HD::Session" do
    patient

    performed_on                      1.week.ago
    start_time                        "11:00"

    association :hospital_unit, factory: :hospital_unit
    association :signed_on_by, factory: :user
  end
end
