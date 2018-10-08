require "migration_helper"

class CreateReportingDailyUKRDCView < ActiveRecord::Migration[5.2]
  include MigrationHelper

  def change
    within_renalware_schema do
      create_view :reporting_daily_ukrdc
    end
  end
end
