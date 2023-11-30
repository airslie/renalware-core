class CreateDuplicateNHSNumbersReportV2 < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      update_view :duplicate_nhs_numbers, version: 2, revert_to_version: 1
    end
  end
end
