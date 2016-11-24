module Renalware
  Drugs::Drug.transaction do
    reset_sequence_sql = nil

    log "Adding Drug Types" do
      Drugs::Drug.transaction do

        %w(Antibiotic ESA Immunosuppressant Peritonitis Controlled).each_with_index do |drug_type, index|
          Drugs::Type.find_or_create_by!(code: drug_type.downcase) do |type|
            type.id = index + 1
            type.name = drug_type
          end
        end

        reset_sequence_sql = <<-SQL.squish
          SELECT setval('%{table_name}_id_seq', (SELECT MAX(id) FROM %{table_name}));
        SQL
        ActiveRecord::Base.connection.execute(
          reset_sequence_sql % { table_name: Renalware::Drugs::Type.table_name }
        )
      end
    end

    log "Adding Drugs" do
      file_path = File.join(File.dirname(__FILE__), "drugs.csv")

      if Drugs::Drug.count == 0
        # Use #import! which is 4 times faster
        drugs = CSV.read(file_path, headers: false)
        columns = drugs[0]
        Drugs::Drug.import! columns, drugs[1..-1], validate: true
      else
        # There are already drugs so use an idempotent approach
        CSV.foreach(file_path, headers: true) do |row|
          Drugs::Drug.find_or_create_by!(name: row["name"]) do |drug|
            drug.id = row["id"]
          end
        end
      end
    end

    log "Assigning Drug Types to Drugs" do
      ActiveRecord::Base.connection.execute(
        reset_sequence_sql % { table_name: Renalware::Drugs::Drug.table_name }
      )

      file_path = File.join(File.dirname(__FILE__), "drug_drug_types.csv")

      CSV.foreach(file_path, headers: true) do |row|
        drug = Drugs::Drug.find(row["drug_id"])
        drug_type = Drugs::Type.find(row["drug_type_id"])
        drug.drug_types << drug_type unless drug.drug_types.include?(drug_type)
      end
    end
  end
end
