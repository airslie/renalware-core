# frozen_string_literal: true

module Renalware
  log "Adding View Metadata" do
    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "transplant_mdm_patients",
      scope: "transplant",
      category: "mdm",
      schema_name: "renalware"
    ) do |view|
      view.slug = "all"
      view.title = "All"
      view.position = 1
      view.filters = {
        sex: :list,
        tx_status: :list,
        on_worryboard: :list,
        tx_in_past_3m: :list,
        tx_in_past_12m: :list,
        patient_name: :search
      }
      view.columns = [].to_json # empty will display all
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "hd_mdm_patients",
      scope: "hd",
      category: "mdm",
      slug: "all",
      schema_name: "renalware"
    ) do |view|
      view.title = "All"
      view.position = 1
      view.filters = {
        schedule: :list,
        hospital_unit: :list,
        named_nurse: :list,
        on_worryboard: :list
      }
      view.columns = [].to_json # empty will display all
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "supportive_care_mdm_patients",
      scope: "supportive_care",
      category: "mdm",
      slug: "all",
      schema_name: "renalware"
    ) do |view|
      view.title = "All"
      view.position = 1
      view.filters = {}
      view.columns = [].to_json
    end
  end
end
