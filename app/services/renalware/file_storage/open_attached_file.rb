# frozen_string_literal: true

module Renalware
  module FileStorage
    class OpenAttachedFile
      def self.call(attached, &)
        MalwareScanning.assert_usable!(attached)

        attached.blob.open(&)
      end
    end
  end
end
