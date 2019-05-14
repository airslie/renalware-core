# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # An ObservationDescription can be a member of many groups (a set of descriptions used for
    # displaying or printing a subset of context-specific results). Within each group,
    # say, 'letters', a description might be in a sub group (which merely serves to pull results
    # together in groups on the page for clarity) and within that group might have a position wich
    # determines its order in the subgroup.
    class CodeGroupMembership < ApplicationRecord
      validates :position_within_subgroup, presence: true
      validates :subgroup, presence: true
      belongs_to :code_group
      belongs_to :observation_description
    end
  end
end
