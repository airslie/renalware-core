require "rails_helper"

module Renalware
  feature "Daily average glucose(ml) calculated from bags per type assigned during one week",
    js: true do
    background do
      @patient = create(:patient)

      @bag_type_13_6 = create(:bag_type,
                    manufacturer: "Baxter",
                    description: "Dianeal PD2 1.36% (Yellow)",
                    glucose_content: 13.6)

      @bag_type_22_7 = create(:bag_type,
                    manufacturer: "Baxter",
                    description: "Dianeal PD2 2.27% (Green)",
                    glucose_content: 22.7)

      @bag_type_38_6 = create(:bag_type,
                    manufacturer: "Baxter",
                    description: "Dianeal PD2 3.86% (Red)",
                    glucose_content: 38.6)

      login_as_clinician

      visit patient_pd_dashboard_path(@patient)
    end

    scenario "should return daily average volume (ml) for each concentration type" do
      click_link "Add CAPD Regime"

      select "CAPD 3 exchanges per day", from: "Treatment"

      fill_in "Start date", with: "18/04/2015"

      # bag 1
      find("a.add-bag").click

      within("#pd-regime-bags div.fields:nth-child(1)") do
        select "Dianeal PD2 1.36% (Yellow)", from: "* Bag type"

        select "2000", from: "Volume (ml)"

        uncheck "Mon"
        uncheck "Wed"
        uncheck "Fri"
        uncheck "Sat"
      end

      # bag 2
      find("a.add-bag").click

      within("#pd-regime-bags div.fields:nth-child(2)") do
        select "Dianeal PD2 2.27% (Green)", from: "* Bag type"

        select "2000", from: "Volume (ml)"

        uncheck "Tue"
        uncheck "Thu"
      end

      # bag 3
      find("a.add-bag").click

      within("#pd-regime-bags div.fields:nth-child(3)") do
        select "Dianeal PD2 3.86% (Red)", from: "* Bag type"

        select "2500", from: "Volume (ml)"

        uncheck "Sun"
        uncheck "Wed"
        uncheck "Fri"
      end

      # bag 4
      find("a.add-bag").click

      within("#pd-regime-bags div.fields:nth-child(4)") do
        select "Dianeal PD2 3.86% (Red)", from: "* Bag type"

        select "2000", from: "Volume (ml)"

        uncheck "Mon"
        uncheck "Wed"
        uncheck "Fri"
        uncheck "Sat"
      end

      click_on "Save"

      expect(page).to have_content("1.36 % 857 ml")
      expect(page).to have_content("2.27 % 1429 ml")
      expect(page).to have_content("3.86 % 2286 ml")
    end
  end
end
