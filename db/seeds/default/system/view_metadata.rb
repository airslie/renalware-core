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
      view.filters = { sex: :list, tx_status: :list, patient_name: :search }
      view.columns = [].to_json # empty will display all
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "transplant_mdm_patients_on_worryboard",
      scope: "transplant",
      category: "mdm",
      schema_name: "renalware"
    ) do |view|
      view.slug = "worryboard"
      view.title = "On Worryboard"
      view.position = 2
      view.filters = { sex: :list, tx_status: :list }
      view.columns = [].to_json # empty will display all
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "transplant_mdm_patients_op_in_past_3m",
      scope: "transplant",
      category: "mdm",
      slug: "op_in_past_3m",
      schema_name: "renalware"
    ) do |view|
      view.title = "Tx in Past 3m"
      view.position = 3
      view.filters = {}
      view.columns = [].to_json # empty will display all
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "transplant_mdm_patients_op_in_past_year",
      scope: "transplant",
      category: "mdm",
      slug: "op_in_past_year",
      schema_name: "renalware"
    ) do |view|
      view.title = "Tx in Past Year"
      view.position = 4
      view.filters = {}
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
      view.filters = { "schedule" => "list", "hospital_unit" => "list" }
      view.columns = [].to_json # empty will display all
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "hd_mdm_patients_on_worryboard",
      scope: "hd",
      category: "mdm",
      slug: "worryboard",
      schema_name: "renalware"
    ) do |view|
      view.title = "On Worryboard"
      view.position = 2
      view.filters = { "schedule" => "list", "hospital_unit" => "list" }
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
