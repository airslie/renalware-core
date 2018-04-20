# frozen_string_literal: true

module Renalware
  log "Adding Import File Types" do
    Feeds::FileType.find_or_create_by!(name: "practices") do |type|
      type.description = "Refresh NHS Practices"
      type.prompt = "Upload fullfile.zip from the HSCOrgRefData zip file you have downloaded from the NHS TRUD site"
      type.download_url_title = "ODS XML Organisation Data (fullfile.zip)",
      type.download_url = "https://isd.digital.nhs.uk/trud3/user/authenticated/group/0/pack/5/subpack/341/releases"
      type.filename_validation_pattern = "/fullfile.zip/i"
    end

    Feeds::FileType.find_or_create_by!(name: "primary_care_physicians") do |type|
      type.description = "Refresh NHS GPs"
      type.prompt = "Upload egpcur.zip from NHS ODS weekly data downloaded from the NHS TRUD site"
      type.download_url_title = "egpcur.zip Current GP"
      type.download_url = "https://isd.digital.nhs.uk/trud3/user/authenticated/group/0/pack/5/subpack/58/releases"
      type.filename_validation_pattern = "/egpcur.zip/i"
    end

    Feeds::FileType.find_or_create_by!(name: "practice_memberships") do |type|
      type.description = "Refresh which NHS Practices each GP is a members of"
      type.prompt = "Upload epracmem.zip from NHS ODS weekly data downloaded from the NHS TRUD site"
      type.download_url_title = "ODS Weekly data on NHS TRUD"
      type.download_url = "https://isd.digital.nhs.uk/trud3/user/authenticated/group/0/pack/5/subpack/58/releases"
      type.filename_validation_pattern = "/epracmem.zip/i"
    end

    # Feeds::FileType.find_or_create_by!(name: "drugs") do |type|
    #   type.description = "Refresh NHS dmd+d drugs"
    #   type.prompt = "Upload the the dmd+d zip file downloaded from the NHS TRUD site"
    #   type.download_url_title = "NHSBSA dm+d on NHS TRUD",
    #   type.download_url = "https://isd.digital.nhs.uk/trud3/user/authenticated/group/0/pack/1/subpack/24/releases"
    #   type.filename_validation_pattern = "/nhsbsa.*\.zip/i"
    # end
  end
end
