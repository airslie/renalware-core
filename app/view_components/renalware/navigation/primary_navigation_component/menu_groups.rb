module Renalware
  module Navigation
    class PrimaryNavigationComponent
      # rubocop:disable-next Metrics/AbcSize, Metrics/ClassLength, Metrics/MethodLength
      class MenuGroups
        rattr_initialize [:component!]

        delegate :hospitals, :main_app, :research, :signed_in?, :t, to: :component

        def to_a
          [
            renal_menu,
            pd_menu,
            hd_menu,
            tx_menu,
            mdm_menu,
            patients_menu,
            help_menu
          ]
        end

        private

        def renal_menu
          {
            id: "renal",
            label: t("renalware.navigation.renal.menu_title"),
            links: [
              [t("renalware.navigation.renal.appointments"), main_app.appointments_path],
              [t("renalware.navigation.renal.clinic_visits"), main_app.clinic_visits_path],
              [t("renalware.navigation.renal.events"), main_app.events_filtered_list_path],
              [t("renalware.navigation.renal.letters"), main_app.letters_list_path],
              [
                t("renalware.navigation.renal.esa_prescriptions"),
                main_app.medications_esa_prescriptions_path
              ],
              [
                t("renalware.navigation.renal.home_delivery_prescriptions"),
                main_app.medications_home_delivery_prescriptions_path(named_filter: "esa")
              ],
              [t("renalware.navigation.renal.aki_alerts"), main_app.renal_aki_alerts_path],
              [t("renalware.navigation.renal.safety_alerts"), main_app.renal_safety_alerts_path],
              [t("renalware.navigation.renal.studies"), research.studies_path],
              [t("renalware.navigation.renal.users"), main_app.users_path],
              [t("renalware.navigation.renal.hospital_units"), hospitals.units_path],
              [
                t("renalware.navigation.renal.renal_registry_checks"),
                main_app.patients_renal_registry_preflight_checks_path
              ]
            ]
          }
        end

        def pd_menu
          {
            id: "pd",
            label: "PD",
            links: [
              ["PET results", main_app.pd_pet_completions_path],
              ["Adequacy results", main_app.pd_adequacy_completions_path]
            ]
          }
        end

        def hd_menu
          {
            id: "hd",
            label: "HD",
            links: [
              [t("renalware.navigation.hd.ongoing_hd_sessions"), main_app.hd_ongoing_sessions_path],
              [t("renalware.navigation.hd.hd_slot_requests"), main_app.hd_slot_requests_path],
              [
                t("renalware.navigation.hd.hd_patients_with_unmet_preferences"),
                main_app.hd_unmet_preferences_path
              ]
            ]
          }
        end

        def tx_menu
          {
            id: "tx",
            label: "Tx",
            links: [
              [
                t("renalware.navigation.tx.tx_wait_list"),
                main_app.transplants_wait_list_path(named_filter: "active")
              ],
              [t("renalware.navigation.tx.live_donors"), main_app.transplants_live_donors_path]
            ]
          }
        end

        def mdm_menu
          {
            id: "mdms",
            label: t("renalware.navigation.mdms.menu_title"),
            links: mdm_links
          }
        end

        def mdm_links
          links = [
            [t("renalware.navigation.mdms.hd"), main_app.hd_mdm_patients_path],
            [t("renalware.navigation.mdms.pd"), main_app.pd_mdm_patients_path],
            [t("renalware.navigation.mdms.transplants"), main_app.transplants_mdm_patients_path],
            [t("renalware.navigation.mdms.low_clearance"), main_app.low_clearance_mdm_patients_path]
          ]

          return links unless signed_in? && Renalware.config.enable_new_mdms

          links + [
            { type: :separator, label: "Beta MDMs" }
          ] + Renalware::Patients::MDMMenu.items.map do |item|
            [item.title, main_app.patients_mdms_path(scope: item.scope, filter: item.filter)]
          end
        end

        def patients_menu
          {
            id: "patients",
            label: t("renalware.navigation.patients_admin.patients"),
            links: [
              ["Patients List", main_app.patients_path],
              ["Add a New Patient", main_app.new_patient_path],
              ["Deceased Patients", main_app.patient_deaths_path],
              ["Worryboard", main_app.worryboard_path],
              ["Admission Requests", main_app.admissions_requests_path],
              ["Admission Consults", main_app.admissions_consults_path],
              ["Admission Inpatients", main_app.admissions_admissions_path]
            ]
          }
        end

        def help_menu
          {
            id: "help",
            label: t("btn.help"),
            links: [
              ["Downloads", main_app.system_downloads_path],
              ["User Guide", Renalware.config.help_user_guide_link],
              ["Training Videos", Renalware.config.help_training_videos_link]
            ]
          }
        end
      end
    end
  end
end
