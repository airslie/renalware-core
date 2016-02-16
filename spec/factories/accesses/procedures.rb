FactoryGirl.define do
  factory :access_procedure, class: Renalware::Accesses::Procedure do
    type { create(:access_type) }
    site { create(:access_site) }
    side "R"
    performed_on { Time.zone.today }
  end
end
