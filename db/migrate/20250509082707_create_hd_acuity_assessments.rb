class CreateHDAcuityAssessments < ActiveRecord::Migration[8.0]
  def down
    drop_table :hd_acuity_assessments
    drop_table :hd_acuity_assessment_levels, if_exists: true
    drop_enum :hd_acuity_assessment_ratios
  end

  def up
    within_renalware_schema do
      drop_table :hd_acuity_assessments, if_exists: true
      drop_table :hd_acuity_assessment_levels, if_exists: true

      create_enum :hd_acuity_assessment_ratios, %w(1:4 1:3 1:2 1:1)

      create_table :hd_acuity_assessments do |t|
        t.references :patient, null: false, foreign_key: { to_table: :patients }
        t.references :created_by, null: false, foreign_key: { to_table: :users }
        t.references :updated_by, null: false, foreign_key: { to_table: :users }

        t.enum :ratio, enum_type: :hd_acuity_assessment_ratios, null: false
        t.timestamps null: false
      end
    end
  end
end
