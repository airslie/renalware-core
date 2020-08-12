# frozen_string_literal: true

module Renalware
  log "Adding Pathology Code Groups" do
    user = User.first

    groups = {
      pd_pet_serum_pathology: {
        description: "Pathology relating to serum taken during a PD PET test." \
                     "position_within_subgroup determines the order inputs are "\
                     "populated in the PET pathology form.",
        codes: %w(URE CRE PGLU NA POT)
      },
      hd_session_form_recent: {
        description: "Recent pathology shown on the HD Sessions PDF print-out",
        codes: %w(HGB PLT CRP POT CCA FER)
      }
    }

    user = User.first

    groups.each do |name, options|
      group = Pathology::CodeGroup.find_or_create_by!(name: name) do |grp|
        grp.description = options[:description]
        grp.created_by = user
        grp.updated_by = user
      end

      Array(options[:codes]).each_with_index do |code, index|
        membership = group.memberships.build
        membership.observation_description = Pathology::ObservationDescription.find_by(code: code)
        membership.subgroup = 1
        membership.position_within_subgroup = index + 1
        membership.save_by! user
      end
    end
  end
end
