# frozen_string_literal: true

require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    module Incoming
      class Paths
        def initialize
          FileUtils.mkdir_p incoming
          FileUtils.mkdir_p archive
        end

        def incoming
          @incoming ||= working_path.join("incoming")
        end

        def archive
          @archive ||= working_path.join("archive", "incoming")
        end

        private

        def working_path
          Pathname(Renalware.config.ukrdc_working_path)
        end
      end
    end
  end
end
