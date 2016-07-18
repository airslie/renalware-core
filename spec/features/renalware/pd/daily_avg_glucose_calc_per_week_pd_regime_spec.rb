require "rails_helper"

module Renalware
  feature "Daily average glucose(ml) calculated from bags per type assigned during one week",
    js: true do
    background do
      @patient = create(:patient)

      @bag_type_13_6 = create(:bag_type,
                    manufacturer: "Baxter",
                    description: "Dianeal PD2 1.36% (Yellow)",
                    glucose_grams_per_litre: 13.6)

      @bag_type_22_7 = create(:bag_type,
                    manufacturer: "Baxter",
                    description: "Dianeal PD2 2.27% (Green)",
                    glucose_grams_per_litre: 22.7)

      @bag_type_38_6 = create(:bag_type,
                    manufacturer: "Baxter",
                    description: "Dianeal PD2 3.86% (Red)",
                    glucose_grams_per_litre: 38.6)

      login_as_clinician

      visit patient_pd_dashboard_path(@patient)
    end

    scenario "should return daily average volume (ml) for each concentration type" do
      click_link "Add CAPD Regime"

      select "CAPD 3 exchanges per day", from: "Treatment"

      fill_in "Start date", with: "18/04/2015"

      #bag 1
      find("a.add-bag").click

      within("#pd-regime-bags div.fields:nth-child(1)") do
        select "Dianeal PD2 1.36% (Yellow)", from: "Bag Type"

        select "2000", from: "Volume (ml)"

        uncheck "Monday"
        uncheck "Wednesday"
        uncheck "Friday"
        uncheck "Saturday"
      end

      #bag 2
      find("a.add-bag").click

      within("#pd-regime-bags div.fields:nth-child(2)") do
        select "Dianeal PD2 2.27% (Green)", from: "Bag Type"

        select "3000", from: "Volume (ml)"

        uncheck "Tuesday"
        uncheck "Thursday"
      end

      #bag 3
      find("a.add-bag").click

      within("#pd-regime-bags div.fields:nth-child(3)") do
        select "Dianeal PD2 3.86% (Red)", from: "Bag Type"

        select "1500", from: "Volume (ml)"

        uncheck "Sunday"
        uncheck "Wednesday"
        uncheck "Friday"
      end

      #bag 4
      find("a.add-bag").click

      within("#pd-regime-bags div.fields:nth-child(4)") do
        select "Dianeal PD2 3.86% (Red)", from: "Bag Type"

        select "2000", from: "Volume (ml)"

        uncheck "Monday"
        uncheck "Wednesday"
        uncheck "Friday"
        uncheck "Saturday"
      end

      click_on "Save"

      expect(page).to have_content("1.36 % 857 ml")
      expect(page).to have_content("2.27 % 2143 ml")
      expect(page).to have_content("3.86 % 1714 ml")
    end
  end
end
