# frozen_string_literal: true

module Renalware
  log "Assigning Drug Types to Drugs" do
    # ActiveRecord::Base.connection.execute(
    #   reset_sequence_sql % { table_name: Renalware::Drugs::Drug.table_name }
    # )

    file_path = File.join(File.dirname(__FILE__), "drug_drug_types.csv")
    classifications = []
    CSV.foreach(file_path, headers: true) do |row|
      classifications << Drugs::Classification.new(
        drug_id: row["drug_id"],
        drug_type_id: row["drug_type_id"]
      )
    end
    Drugs::Classification.import! classifications
  end
end
