FactoryBot.define do
  factory :access_procedure, class: Renalware::Accesses::Procedure do
    type { create(:access_type) }
    side "R"
    performed_on { Time.zone.today }
  end
end
