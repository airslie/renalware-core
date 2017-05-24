FactoryGirl.define do
  factory :pd_assessment, class: "Renalware::PD::Assessment" do
    patient
    association :updated_by, factory: :user
    association :created_by, factory: :user
    document {
      {
        had_home_visit: :yes,
        home_visit_on: I18n.l(Time.zone.now),
        housing_type: :patient,
        occupant_notes: "occupant notes",
        exchange_area: "exchange area",
        handwashing: "handwashing",
        fluid_storage: "fluid storage",
        bag_warming: "bag warming",
        delivery_frequency: "delivery frequency"
      }
    }
  end
end
