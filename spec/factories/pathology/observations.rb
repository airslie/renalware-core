FactoryGirl.define do
  factory :pathology_observation, class: "Renalware::Pathology::Observation" do
    association :description, factory: :pathology_observation_description
    association :request, factory: :pathology_observation_request
    result "6.0"
    comment "My Comment"
    observed_at "2016-03-04 10:15:40"
  end
end
