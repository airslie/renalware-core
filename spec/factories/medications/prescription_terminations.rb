FactoryGirl.define do
  factory :prescription_termination, class: "Renalware::Medications::PrescriptionTermination" do
    terminated_on "2016-07-26"
    association :created_by, factory: :user
    association :updated_by, factory: :user
  end
end
