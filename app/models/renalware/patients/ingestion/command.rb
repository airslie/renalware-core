# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    module Ingestion
      class Command
        attr_reader :message

        def initialize(message)
          @message = message
        end

        def self.for(message)
          CommandFactory.new.for(message)
        end

        def call
          raise NotImplementedError
        end
      end
    end
  end
end
