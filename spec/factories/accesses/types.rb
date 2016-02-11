FactoryGirl.define do
  factory :access_type,
    class: Renalware::Accesses::Type do
    name "Tunnelled Line"
    code "02"
  end
end
