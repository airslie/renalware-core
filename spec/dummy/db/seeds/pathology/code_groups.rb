# frozen_string_literal: true

module Renalware
  log "Adding Pathology Code Groups" do
    user = User.first
    group = Pathology::CodeGroup.find_or_create_by!(name: "hd_session_form_recent") do |group|
      group.description = "Recent pathology shown on the HD Sessions PDF print-out"
      group.created_by = user
      group.updated_by = user
    end

    %w(HGB PLT CRP).each_with_index do |code, index|
      membership = group.memberships.build
      membership.observation_description = Pathology::ObservationDescription.find_by(code: code)
      membership.subgroup = 1
      membership.position_within_subgroup = index + 1
      membership.save_by! user
    end
  end
end
