# frozen_string_literal: true

module Renalware
  log "Adding Demo Modality Descriptions" do
    [
      %w(LOST lost),
      %w(Nephrology nephrology),
      ["Potential LD", "potential_ld"],
      ["Supportive Care", "supportive_care"],
      ["Transfer Out", "transfer_out"],
      %(Transplant transplant),
      %(vCKD vckd),
      ["Waiting List", "waiting_list"]
    ].each do |name, code|
      Modalities::Description.find_or_create_by!(name: name, code: code)
    end
  end
end
