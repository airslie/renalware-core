class CorrectTristateBooleans < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        # The following columns are tristate booleans, so they should not be nullable

        # paediatric_patient_indicator should default to false and any existing null values be
        # set to false
        change_column_null :patients, :paediatric_patient_indicator, false, false
        change_column_default :patients, :paediatric_patient_indicator, from: nil, to: false

        # These already default to true so we don't need to change the default
        change_column_null :patients, :cc_on_all_letters, false, true
        change_column_null :patient_practices, :active, false, true

        # These already default to false so we don't need to change the default
        change_column_null :users, :approved, false, false
        change_column_null :hospital_units, :is_hd_site, false, false
        change_column_null :hospital_centres, :is_transplant_site, false, false
        change_column_null :hospital_centres, :default_site, false, false
        change_column_null :drug_dmd_matches, :approved_vtm_match, false, false
        change_column_null :drug_dmd_virtual_therapeutic_moieties, :inactive, false, false
        change_column_null :drug_trade_family_classifications, :enabled, false, false
        change_column_null :system_view_metadata, :materialized, false, false
      end
    end
  end
end
