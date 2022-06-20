# frozen_string_literal: true

module Renalware
  log "Adding User Groups" do
    all_user_ids = User.pluck(:id)
    user_ids = [all_user_ids.sample, all_user_ids.sample, all_user_ids.sample].uniq
    Users::Group.create!(
      name: "Transplant Coordinators",
      user_ids: user_ids,
      letter_electronic_ccs: true,
      by: User.first
    )
  end
end
