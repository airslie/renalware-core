FactoryGirl.define do
  factory :pathology_observation_request, class: "Renalware::Pathology::ObservationRequest" do
    pcs_code "123"
    requestor_name "Jane Doe"
    observed_at "2016-03-04 10:14:49"
  end
end
