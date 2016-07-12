module Renalware
  sitecode = 'BARTS'
  log "--------------------Adding #{sitecode} Modality Descriptions--------------------"

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

  log "Link Modality Descriptions for PD"
  # These are required to determine if a patient was treated with PD

  %w(pd apd capd).each do |modality_system_code|
    description = Modalities::Description.find_by!(system_code: modality_system_code)
    PD::ModalityDescription.create!(description: description)
  end
end
