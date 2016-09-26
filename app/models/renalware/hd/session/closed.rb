# This Closed (state) Session adds validation standard HD::Session to enforce the presence of
# most fields.
module Renalware
  module HD
    class Session::Closed < ActiveType::Record[Session]

      validates :signed_off_by, presence: true
      validates :end_time, presence: true

      class SessionDocument < ::Renalware::HD::SessionDocument
        class Info < Renalware::HD::SessionDocument::Info
          validates_presence_of attribute_set.map(&:name)
        end
        attribute :info, Info

        class Observations < Renalware::HD::SessionDocument::Observations
          validates_presence_of attribute_set.map(&:name)
        end
        attribute :observations_before, Observations
        attribute :observations_after, Observations

        class Dialysis < Renalware::HD::SessionDocument::Dialysis
          validates_presence_of attribute_set.map(&:name)
        end
        attribute :dialysis, Dialysis

        class HDF < Renalware::HD::SessionDocument::HDF
          # TODO: this needs to be conditional but we don't have the pieces in play yet
          #       to apply conditional validation here - we would need to either know about
          #       the state of the session (bad) or apply the validation on a per instance
          #       basis (possible but we'd have to add it to the singleton class), use use a
          #       custom validator injected at the session level.
          validates_presence_of attribute_set.map(&:name)
        end
        attribute :hdf, HDF
      end

      has_document class_name: "::Renalware::HD::Session::Closed::SessionDocument"
    end
  end
end
