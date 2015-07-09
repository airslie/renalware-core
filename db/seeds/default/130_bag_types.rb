log '--------------------Adding BagTypes--------------------'
file_path = File.join(default_path, 'bag_types.csv')

logcount=0
CSV.foreach(file_path, headers: true) do |row|
  logcount += 1
  BagType.find_or_create_by!(
    description: row['description'],
    manufacturer: row['manufacturer'],
    glucose_ml_percent_1_36: row['glucose_ml_percent_1_36'],
    glucose_ml_percent_2_27: row['glucose_ml_percent_2_27'],
    glucose_ml_percent_3_86: row['glucose_ml_percent_3_86'],
    amino_acid_ml: row['amino_acid_ml'],
    icodextrin_ml: row['icodextrin_ml'],
    low_glucose_degradation: row['low_glucose_degradation'],
    low_sodium: row['low_sodium'],
  )
end

log "#{logcount} BagTypes seeded"
