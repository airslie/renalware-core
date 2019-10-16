# frozen_string_literal: true

require "renalware/engine"
require "renalware/configuration"

module Renalware
  # Configure Webpacker instance.
  # See https://github.com/rails/webpacker/blob/master/docs/engines.md
  class << self
    def webpacker
      @webpacker ||= begin
        root_path = Pathname.new(File.join(__dir__, ".."))
        ::Webpacker::Instance.new(
          root_path: root_path,
          config_path: root_path.join("config/webpacker.yml")
        )
      end
    end
  end
end
