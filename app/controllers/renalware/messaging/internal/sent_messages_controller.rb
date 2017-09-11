require_dependency "renalware/messaging"
require "collection_presenter"

module Renalware
  module Messaging
    module Internal
      class SentMessagesController < BaseController
        include Renalware::Concerns::Pageable

        def index
          messages = author.messages.page(page).per(per_page)
          authorize messages
          render locals: {
            messages: CollectionPresenter.new(messages, Messaging::MessagePresenter)
          }
        end

        def author
          Messaging.cast_author(current_user)
        end
      end
    end
  end
end
