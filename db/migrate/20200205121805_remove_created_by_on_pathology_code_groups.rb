class RemoveCreatedByOnPathologyCodeGroups < ActiveRecord::Migration[5.2]
  # Remove null constraints on path group tables so that we can add group data using
  # db:migrate:with_data on an empty database where there are no users - eg in CI.
  within_renalware_schema do
    change_column_null :pathology_code_groups, :created_by_id, true
    change_column_null :pathology_code_groups, :updated_by_id, true
    change_column_null :pathology_code_group_memberships, :created_by_id, true
    change_column_null :pathology_code_group_memberships, :updated_by_id, true
  end
end
