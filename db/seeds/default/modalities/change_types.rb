# frozen_string_literal: true

require_relative "../../seeds_helper"

module Renalware
  module Modalities
    extend SeedsHelper

    log "Adding modality change types.." do
      user = SystemUser.find
      {
        haemodialysis_to_pd: {
          name: "Haemodialysis To PD"
        },
        pd_to_haemodialysis: {
          name: "PD To Haemodialysis"
        },
        other: {
          name: "Other",
          default: true
        },
        transferred_in: {
          name: "Transferred in",
          require_source_hospital_centre: true
        },
        transferred_out: {
          name: "Transferred out",
          require_destination_hospital_centre: true
        }
      }.each do |code, options|
        ChangeType.find_or_create_by!(code: code, name: name) do |ct|
          ct.assign_attributes(options)
          ct.created_by_id = ct.updated_by_id = user.id
        end
      end
    end
  end
end
