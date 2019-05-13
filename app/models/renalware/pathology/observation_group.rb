# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Represents a set of observation descriptions that are displayed together for example on a
    # letter on or an HD MDM.
    # We don't always want to display the same set of results. For example in the context of
    # an HD MDM we might want to display only HD-relevant results, while in the main historical
    # pathology view we want to see a wide set of results.
    # By defining a group with a name like 'letters' or 'pd_mdm' we can load and display
    # only the results in that group.
    class ObservationGroup < ApplicationRecord
      validates :name, presence: true, uniqueness: true
      has_many(
        :memberships,
        class_name: "ObservationGroupMembership",
        foreign_key: "group_id",
        dependent: :destroy
      )
      has_many(
        :descriptions,
        class_name: "ObservationDescription",
        through: :memberships,
        foreign_key: "description_id"
      )
    end
  end
end
