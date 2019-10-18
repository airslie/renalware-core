class CreateHDDiaryMatrixView < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_view :hd_diary_matrix
    end
  end
end
