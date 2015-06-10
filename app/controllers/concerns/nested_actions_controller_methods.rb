require 'active_support/concern'

module NestedActionsControllerMethods
  extend ActiveSupport::Concern

  included do
    # Allows add and remove form submissions for a nested collection
    #
    # @params
    # model - the parent model
    # collection - the nested collection where items are added or removed
    # build_attrs - attributes to pass to collection#build when adding to the collection
    #
    def perform_action(model, collection, build_attrs={})
      if (actions = params[:actions]).present?
        associated = model.send(collection)
        if actions.key?(:remove)
          index = actions[:remove].keys.first.to_i
          associated.delete(associated[index])
        else
          associated.build(build_attrs)
        end
        false
      else
        model.save
      end
    end
  end
end
