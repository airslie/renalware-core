require_dependency "renalware/messaging"

module Renalware
  module Modalities
    class DescriptionPolicy < BasePolicy
      # For safety we currently disallow the deletion of any ModalityDescription
      def destroy?
        false
      end

      # Its only possible to edit a ModalityDescription (e.g. to change its name) when it has no
      # (STI) type - ie its not a system-required ModalityDescription.
      def edit?
        record.type.nil?
      end

      def update?
        edit?
      end
    end
  end
end
