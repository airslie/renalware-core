class AddLegacyCommentToPathologyObservations < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :pathology_observations, :legacy_comment, :text
    end
  end
end
