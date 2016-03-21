FactoryGirl.define do
  factory :pathology_observation, class: "Renalware::Pathology::Observation" do
    result "6.0"
    comment "My Comment"
    observed_at "2016-03-04 10:15:40"
  end
end
