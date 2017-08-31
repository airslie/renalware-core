FactoryGirl.define do
  factory :hd_weekly_diary, class: "Renalware::HD::WeeklyDiary" do
    year 2017
    week_number 2
    master false
  end

  factory :hd_master_diary, class: "Renalware::HD::MasterDiary" do
    master true
  end
end
