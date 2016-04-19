FactoryGirl.define do
  factory :pathology_observation_request, class: "Renalware::Pathology::ObservationRequest" do
    association :description, factory: :pathology_request_description
    patient
    requestor_order_number "123"
    requestor_name "Jane Doe"
    requested_at "2016-03-04 10:14:49"
  end
end
