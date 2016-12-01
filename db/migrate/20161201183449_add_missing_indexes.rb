class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :access_profiles, :type_id
    add_index :access_profiles, :site_id
    add_index :access_profiles, :plan_id
    add_index :roles_users, [:user_id, :role_id]
    add_index :access_procedures, :type_id
    add_index :access_procedures, :site_id
    add_index :modality_descriptions, [:id, :type]
    add_index :patients, :ethnicity_id
    add_index :patients, :religion_id
    add_index :patients, :language_id
    add_index :patients, :first_edta_code_id
    add_index :patients, :second_edta_code_id
    add_index :patients, :practice_id
    add_index :modality_modalities, [:patient_id, :description_id]
    add_index :modality_modalities, :patient_id
    add_index :pathology_requests_global_rules, [:id, :type]
    add_index :pathology_requests_global_rules,
              [:rule_set_id, :rule_set_type],
              name: :prgr_rule_set_id_and_rule_set_type_idx
    add_index :hd_sessions, [:id, :type]
    add_index :clinics, :user_id
    add_index :transplant_registration_statuses, :created_by_id
    add_index :transplant_registration_statuses, :updated_by_id
    add_index :clinics_appointments, :patient_id
    add_index :clinics_appointments, :clinic_id
    add_index :clinics_appointments, :user_id
    add_index :transplant_recipient_operations, :hospital_centre_id
    add_index :transplant_recipient_followups,
              :transplant_failure_cause_description_id,
              name: :tx_recip_fol_failure_cause_description_id_idx
    add_index :access_assessments, :type_id
    add_index :access_assessments, :site_id
    add_index :pathology_requests_requests, :created_by_id
    add_index :pathology_requests_requests, :updated_by_id
    add_index :pathology_requests_requests, :patient_id
    add_index :pathology_requests_requests, :clinic_id
    add_index :pathology_requests_requests, :consultant_id
    add_index :pathology_requests_patient_rules_requests,
              :patient_rule_id,
              name: :prprr_patient_rule_id_idx
    add_index :pathology_requests_patient_rules_requests, :request_id
    add_index :pathology_request_descriptions_requests_requests,
              :request_description_id,
              name: :prdr_requests_description_id_idx
    add_index :pathology_request_descriptions_requests_requests,
              :request_id,
              name: :prdr_requests_request_id_idx
    add_index :pathology_requests_drugs_drug_categories,
              :drug_category_id,
              name: :prddc_drug_category_id_idx
    add_index :pathology_requests_drugs_drug_categories, :drug_id
    add_index :pathology_requests_global_rule_sets,
              :request_description_id,
              name: :prddc_request_description_id_idx
    add_index :pathology_requests_global_rule_sets, :clinic_id
    add_index :pathology_requests_patient_rules, :patient_id
    add_index :pathology_requests_patient_rules, :lab_id
    add_index :transplant_failure_cause_descriptions, :group_id
    add_index :problem_problems, :patient_id
    add_index :pd_regimes, :patient_id
    add_index :pd_regimes, :system_id
    add_index :pd_regimes, [:id, :type]
    add_index :letter_letters, [:id, :type]
    add_index :events, :patient_id
    add_index :events, :event_type_id
    add_index :letter_contacts, :description_id
    add_index :hospital_units, :hospital_centre_id
    add_index :pd_exit_site_infections, :patient_id
    add_index :modality_reasons, [:id, :type]
    add_index :clinic_visits, :clinic_id
    add_index :pathology_request_descriptions,
              :required_observation_description_id,
              name: :prd_required_observation_description_id_idx
    add_index :pathology_request_descriptions, :lab_id
    add_index :pd_peritonitis_episodes, :patient_id
    add_index :pd_regime_bags, :bag_type_id
    add_index :pd_regime_bags, :regime_id
    add_index :renal_profiles, :patient_id
    add_index :renal_profiles, :prd_description_id
  end
end
