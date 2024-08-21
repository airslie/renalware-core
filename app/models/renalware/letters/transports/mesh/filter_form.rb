# frozen_string_literal: true

module Renalware
  module Letters::Transports::Mesh
    # Form object to help us build and parse the appropriate filters for the
    # mesh letters controller.
    class FilterForm
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :s, :string # sort order, not really part of the form
      attribute :gp_send_status_eq, :string
      attribute :ods_code_mismatch_eq, :boolean
    end
  end
end
