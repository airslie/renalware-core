FactoryGirl.define do
  factory :events_type, class: "Renalware::Events::Type" do
    name "Access--Clinic"

    factory :swab_event_type do
      name "Swab"
      event_class_name "Renalware::Events::Swab"
      slug "swabs"
    end
  end
end
