module Renalware
  sitecode = 'BARTS'
  log "--------------------Adding #{sitecode} Modality Codes & Descriptions--------------------"

  file_path = File.join(default_path, 'modality_descriptions_barts.csv')
  log_count = 0
  CSV.foreach(file_path, headers: true) do |row|
    log_count += 1
    system_code = row['system_code']
    modal_name = row['name']

    Modalities::Description.find_or_create_by!(name: modal_name) do |description|
      description.name = modal_name
      description.system_code = system_code
    end
    log "--#{modal_name}"
  end

  log "#{log_count} Modality Codes seeded"
end
