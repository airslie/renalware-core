require_dependency "renalware/messaging"

module Renalware
  module Messaging
    class SendMessage

      def self.call(*args)
        new.call(*args)
      end

      def call(author:, patient:, form:)
        Message.transaction do
          message = MessageFactory.build(patient: patient,
                                         author: author,
                                         **form.attributes)
          message.save!
          message
        end
      end
    end
  end
end
