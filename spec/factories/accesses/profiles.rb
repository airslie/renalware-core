FactoryGirl.define do
  factory :access_profile, class: Renalware::Accesses::Profile do
    type { create(:access_type) }
    site { create(:access_site) }
    side "R"
  end
end
