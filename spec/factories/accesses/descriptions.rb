FactoryGirl.define do
  factory :access_description,
    class: Renalware::Accesses::Description do
    name "Tunnelled Line"
    code "02"
  end
end
