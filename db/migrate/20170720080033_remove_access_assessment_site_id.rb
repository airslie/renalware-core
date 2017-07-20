class RemoveAccessAssessmentSiteId < ActiveRecord::Migration[5.0]
  def change
    remove_column :access_assessments, :site_id, :integer
  end
end
