require_dependency "renalware/messaging"

module Renalware
  module Messaging
    class Author < ActiveType::Record[Renalware::User]
      has_many :messages
    end
  end
end
