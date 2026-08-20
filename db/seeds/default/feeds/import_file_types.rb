require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Import File Types" do
    Feeds::FileType.find_or_initialize_by(name: "primary_care_physicians").tap do |type|
      type.description = "Refresh NHS GPs"
      type.prompt = "Upload the egpcur CSV report from NHS ODS Data Search and Export"
      type.download_url_title = "Download current egpcur CSV"
      type.download_url =
        "https://www.odsdatasearchandexport.nhs.uk/api/getReport?report=egpcur"
      type.filename_validation_pattern = "/egpcur\\.(csv|zip)/i"
      type.save!
    end

    Feeds::FileType.find_or_initialize_by(name: "practice_memberships").tap do |type|
      type.description = "Refresh which NHS Practices each GP is a members of"
      type.prompt = "Upload the epracmem CSV report from NHS ODS Data Search and Export"
      type.download_url_title = "Download current epracmem CSV"
      type.download_url =
        "https://www.odsdatasearchandexport.nhs.uk/api/getReport?report=epracmem"
      type.filename_validation_pattern = "/epracmem\\.(csv|zip)/i"
      type.save!
    end

    # Feeds::FileType.find_or_create_by!(name: "drugs") do |type|
    #   type.description = "Refresh NHS dm+d drugs"
    #   type.prompt = "Upload the the dm+d zip file downloaded from the NHS TRUD site"
    #   type.download_url_title = "NHSBSA dm+d on NHS TRUD",
    #   type.download_url = "https://isd.digital.nhs.uk/trud3/user/authenticated/group/0/pack/1/subpack/24/releases"
    #   type.filename_validation_pattern = "/nhsbsa.*\.zip/i"
    # end
  end
end
