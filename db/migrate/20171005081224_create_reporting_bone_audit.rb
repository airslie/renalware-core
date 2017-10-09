class CreateReportingBoneAudit < ActiveRecord::Migration[5.0]
  def change
    create_view :reporting_bone_audit
  end
end
