FactoryBot.define do
  factory :events_type, class: "Renalware::Events::Type" do
    name "Access--Clinic"

    factory :swab_event_type do
      name "Swab"
      event_class_name "Renalware::Events::Swab"
      slug "swabs"
    end

    factory :pd_line_change_event_type do
      name "PD Line Change"
      slug "pd_line_changes"
    end
  end
end
