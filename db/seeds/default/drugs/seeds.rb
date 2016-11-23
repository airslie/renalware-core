module Renalware
  reset_sequence_sql = nil

  log "Adding Drug Types" do

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

  log "Adding Drugs" do
    file_path = File.join(File.dirname(__FILE__), "drugs.csv")

    Drugs::Drug.transaction do
      drugs = CSV.read(file_path, headers: false)
      columns = drugs[0]
      Drugs::Drug.import! columns, drugs[1..-1], validate: true
    end
  end

  ActiveRecord::Base.connection.execute(
    reset_sequence_sql % { table_name: Renalware::Drugs::Drug.table_name }
  )

  log "Assigning Drug Types to Drugs" do

    file_path = File.join(File.dirname(__FILE__), "drug_drug_types.csv")

    Drugs::Drug.transaction do
      CSV.foreach(file_path, headers: true) do |row|
        drug = Drugs::Drug.find(row["drug_id"])
        drug_type = Drugs::Type.find(row["drug_type_id"])
        drug.drug_types << drug_type unless drug.drug_types.include?(drug_type)
      end
    end
  end
end
