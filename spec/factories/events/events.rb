FactoryGirl.define do
  factory :event, class: "Renalware::Events::Event" do
    patient
    event_type factory: :events_type
    date_time Time.zone.now
    description "Needs blood sample taken."
    notes "Would like son to accompany them on clinic visit."
    association :created_by, factory: :user
    association :updated_by, factory: :user

    factory :simple_event, class: "Renalware::Events::Simple" do

    end
  end
end
