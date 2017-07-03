module World
  module Renal::Profile
    module Domain
      def edit_renal_profile(user, patient)
        # noop
      end

      def update_renal_profile(user, patient)
        # noop
      end

      def expect_renal_profile_to_be_updated(user, patient)
        # noop
      end
    end

    module Web
      include Domain

      def edit_renal_profile(user, patient)
        login_as user
        visit edit_patient_renal_profile_path(patient)
      end

      def update_renal_profile(user, patient)
        fill_in "ESRF Date", with: fake_date.to_s
        fill_autocomplete "form.simple_form",
                          "prd_description_auto_complete",
                          with: "Cystinuria",
                          select: "Cystinuria"

        within_fieldset "Low Clearance" do
          fill_in low_clearance_t("first_seen_on"), with: fake_date
          select "CAPD LA", from: low_clearance_t("dialysis_plan")
          fill_in low_clearance_t("dialysis_planned_on"), with: fake_date
          fill_in low_clearance_t("predicted_esrf_date"), with: fake_date
          fill_in low_clearance_t("referral_creatinine"), with: "123"
          fill_in low_clearance_t("referral_egfr"), with: "456"
          fill_in low_clearance_t("referred_by"), with: "A User"
          select "Attended", from: low_clearance_t("education_status")
          select "Day", from: low_clearance_t("education_type")
          fill_in low_clearance_t("attended_on"), with: fake_date
          find("div.radio_buttons", text: low_clearance_t("dvd1_provided")).choose("Yes")
          find("div.radio_buttons", text: low_clearance_t("dvd2_provided")).choose("No")
          find("div.radio_buttons", text: low_clearance_t("transplant_referral")).choose("Yes")
          fill_in low_clearance_t("transplant_referred_on"), with: fake_date
          find("div.radio_buttons", text: low_clearance_t("home_hd_possible")).choose("Yes")
          find("div.radio_buttons", text: low_clearance_t("self_care_possible")).choose("Yes")
          fill_in low_clearance_t("access_notes"), with: "Notes"
        end

        within page.first(".form-actions") do
          click_on "Save"
        end

        expect(page.current_path).to eq(patient_renal_profile_path(patient))
      end

      def expect_renal_profile_to_be_updated(user, patient)
        profile = Renalware::Renal.cast_patient(patient).profile.reload

        expect(profile.esrf_on).to eq(fake_date)
        expect(profile.prd_description.term).to eq("Cystinuria")

        low_clearance = profile.document.low_clearance
        expect(low_clearance.first_seen_on).to eq(fake_date)
        expect(low_clearance.dialysis_plan).to eq("capd_la")
        expect(low_clearance.dialysis_planned_on).to eq(fake_date)
        expect(low_clearance.predicted_esrf_date).to eq(fake_date)
        expect(low_clearance.referral_creatinine).to eq(123)
        expect(low_clearance.referral_egfr).to eq(456)
        expect(low_clearance.referred_by).to eq("A User")
        expect(low_clearance.education_status).to eq("attended")
        expect(low_clearance.education_type).to eq("day")
        expect(low_clearance.dvd1_provided).to eq("yes")
        expect(low_clearance.dvd2_provided).to eq("no")
        expect(low_clearance.transplant_referral).to eq("yes")
        expect(low_clearance.transplant_referred_on).to eq(fake_date)
        expect(low_clearance.home_hd_possible).to eq("yes")
        expect(low_clearance.self_care_possible).to eq("yes")
        expect(low_clearance.access_notes).to eq("Notes")
      end

      private

      def low_clearance_t(key)
        scope = "activemodel.attributes.renalware/renal/profile_document/low_clearance"
        I18n.t(key, scope: scope)
      end
    end
  end
end
