
module World
  module PD
    module Domain
      def record_pet_adequacy_for(patient:, user:)
        patient = pd_patient(patient)
        result = patient.pet_adequacy_results.new
        result.by = user

        numeric_attributes.each do |att|
          result[att] = max_value_for(att)
        end

        result.pet_type = Renalware::PD::PETAdequacyResult.pet_type.values.first
        result.pet_date = Time.zone.today
        result.adequacy_date = Time.zone.today
        result.date_rff = Time.zone.today
        result.date_creat_value = Time.zone.today
        result.date_creat_clearance = Time.zone.today

        result.save!
        result
      end

      def expect_patient_to_have_pet_adequacy(patient:, pet_adequacy:)
        patient = pd_patient(patient)
        expect(patient.pet_adequacy_results.reload.length).to eq(1)
        expect(patient.pet_adequacy_results.first).to eq(pet_adequacy)
      end

      private

      def numeric_attributes
        %i(pet_duration pet_net_uf adequacy_date
           dialysate_creat_plasma_ratio dialysate_glucose_start
           dialysate_glucose_end ktv_total ktv_dialysate ktv_rrf ktv_total
           crcl_total crcl_dialysate crcl_rrf
           daily_uf daily_urine creat_value
           dialysate_effluent_volume
           urine_urea_conc urine_creat_conc)
      end

      def max_value_for(field)
        Renalware::PD::PETAdequacyResult::MAXIMUMS[field.to_sym]
      end
    end

    module Web
      include Domain

      def record_pet_adequacy_for(patient:, user:)
        login_as user
        visit patient_pd_dashboard_path(patient)

        within ".page-actions" do
          click_on t_dashboard(".add_pet_adequacy")
        end

        expect(page).to have_current_path(new_patient_pd_pet_adequacy_result_path(patient))

        within(".pet-adequacy-form") do
          choose "Fast"
          fill_in t_model(".pet_date"), with: I18n.l(Time.zone.today)
          fill_in t_model(".adequacy_date"), with: I18n.l(Time.zone.today)
          fill_in t_model(".date_rff"), with: I18n.l(Time.zone.today)
          fill_in t_model(".date_creat_value"), with: I18n.l(Time.zone.today)
          fill_in t_model(".date_creat_clearance"), with: I18n.l(Time.zone.today)

          numeric_attributes.each do |att|
            fill_in(t_model(".#{att}"), with: max_value_for(att))
          end

          click_on(t(".save"))
        end
      end

      def expect_patient_to_have_pet_adequacy(patient:, pet_adequacy:)
        within ".pet-adequacies" do
          expect(page.all("tbody tr").length).to eq(1)
          expect(page).to have_content(I18n.l(Time.zone.today))
        end
      end

      private

      def t(key, scope: "renalware.pd.pet_adequacy_results.form")
        I18n.t(key, scope: scope, cascade: true)
      end

      def t_model(key, scope: "activerecord.attributes.renalware/pd/pet_adequacy_result")
        I18n.t(key, scope: scope, cascade: true)
      end

      def t_dashboard(key, scope: "renalware.pd.dashboards.show.page_actions")
        I18n.t(key, scope: scope, cascade: true)
      end
    end
  end
end
