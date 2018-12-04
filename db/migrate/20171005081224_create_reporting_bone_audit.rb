class CreateReportingBoneAudit < ActiveRecord::Migration[5.0]
  def change
    within_renalware_schema do
      create_view :reporting_bone_audit
    end
  end
end
