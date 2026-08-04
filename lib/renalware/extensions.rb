# frozen_string_literal: true

module Renalware
  module Extensions
    module_function

    def enabled
      load_dotenv

      ENV.fetch("RENALWARE_EXTENSIONS", "")
        .split(",")
        .map { |name| normalize(name) }
        .reject(&:empty?)
        .uniq
    end

    def enabled?(name)
      enabled.include?(normalize(name))
    end

    def normalize(name)
      name.to_s.strip.downcase
    end
    private_class_method :normalize

    def load_dotenv
      return unless defined?(Dotenv)

      Dotenv.load
    end
    private_class_method :load_dotenv
  end
end
