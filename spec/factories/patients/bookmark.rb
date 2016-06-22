FactoryGirl.define do
  factory :patients_bookmark, class: "Renalware::Patients::Bookmark" do
    association :user, factory: :patients_user
    association :patient, factory: :patient
  end
end
