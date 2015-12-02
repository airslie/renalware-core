require 'active_support/concern'

module Renalware
  module Concerns::NestedActionsControllerMethods
    extend ActiveSupport::Concern

    included do
      # Allows add and remove form submissions for a nested collection
      #
      # @params
      # nested - the nested collection where items are added or removed
      # default_action - the update or save action wrapped in a proc
      # build_attrs - attributes to pass to collection#build when adding to the collection
      #
      def perform_action(nested, default_action, build_attrs={})
        if (actions = params[:actions]).present?
          if actions.key?(:remove)
            index = actions[:remove].keys.first.to_i
            nested.destroy(nested[index])
          else
            nested.build(build_attrs)
          end
          false
        else
          default_action.call
        end
      end
    end
  end
end