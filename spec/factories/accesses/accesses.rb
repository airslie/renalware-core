FactoryGirl.define do
  factory :access,
    class: Renalware::Accesses::Access do
    type { create(:access_type) }
    site { create(:access_site) }
    side "R"
  end
end
