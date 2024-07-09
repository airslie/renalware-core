class CreatePDMDMPatientsV8 < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      update_view :pd_mdm_patients, version: 8, revert_to_version: 7

      reversible do |direction|
        direction.down do
          # noop
        end
        direction.up do
          Renalware::System::ViewMetadata
            .where(view_name: "pd_mdm_patients")
            .update(
              filters: [
                {
                  code: "on_worryboard",
                  type: 0
                },
                {
                  code: "hospital_centre",
                  type: 0
                },
                {
                  code: "named_consultant",
                  type: 0
                },
                {
                  code: "named_nurse",
                  type: 0
                }
              ]
            )
        end
      end
    end
  end
end
