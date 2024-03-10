# frozen_string_literal: true

require_relative "configuration"

module Renalware
  module Reporting
    class Engine < Rails::Engine
      isolate_namespace Reporting

      initializer :add_locales do |app|
        app.config.i18n.load_path += Dir[config.root.join("app/components/**/*.yml")]
      end
    end
  end
end
