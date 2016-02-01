FactoryGirl.define do
  factory :event, class: "Renalware::Events::Event" do
    patient
    event_type
    date_time Time.now
    description "Needs blood sample taken."
    notes "Would like son to accompany them clinic visit."
  end
end
