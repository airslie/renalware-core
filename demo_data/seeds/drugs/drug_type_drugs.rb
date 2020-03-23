# frozen_string_literal: true

module Renalware
  log "Assigning Drug Types to Drugs" do
    # We only needed this because we used to seed the drug id as well as the name, and this meant
    # the sequence got out of sync
    # table_name = Renalware::Drugs::Drug.table_name
    # ActiveRecord::Base.connection.execute(<<-SQL.squish)
    #   SELECT pg_catalog.setval(pg_get_serial_sequence('#{table_name}', 'id'),
    #   MAX(id)) FROM #{table_name};
    # SQL

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
