FactoryBot.define do
  factory :hd_diary_slot, class: "Renalware::HD::DiarySlot" do
    association :diurnal_period_code_id, :am, factory: :hd_diurnal_period_code
    association :patient
    association :station, factory: :hd_station
  end
end
