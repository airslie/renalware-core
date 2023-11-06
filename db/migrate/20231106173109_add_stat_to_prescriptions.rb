class AddStatToPrescriptions < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column(
        :medication_prescriptions,
        :stat,
        :boolean,
        index: true,
        comment: "Can be chosen when administer_on_hd is true. Prescriptions marked as 'stat' " \
                 "will be marked as terminated automatically once given."
      )
    end
  end
end
