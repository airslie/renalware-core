# frozen_string_literal: true

module Renalware
  log "Adding User Groups" do
    user_ids = User.pluck(:id).sample(4)
    Users::Group.create!(
      name: "Transplant Coordinators",
      user_ids: user_ids,
      letter_electronic_ccs: true,
      by: User.first
    )
  end
end
