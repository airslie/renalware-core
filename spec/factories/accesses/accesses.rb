FactoryGirl.define do
  factory :access,
    class: Renalware::Accesses::Access do
    description { create(:access_description) }
    site { create(:access_site) }
    side "R"
  end
end
