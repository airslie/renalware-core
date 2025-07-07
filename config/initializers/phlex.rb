# frozen_string_literal: true

module Views
end

module Components
  # With this extend you can do `Component(attrs)`
  # instead of `render Component.new(attrs)`
  extend Phlex::Kit
end

module Shared
  extend Phlex::Kit
end

module Renalware
  include Shared
end

ENGINE = Renalware::Engine.root
Rails.autoloaders.main.push_dir(ENGINE.join("app/views"), namespace: Views)
Rails.autoloaders.main.push_dir(ENGINE.join("app/components/shared"), namespace: Shared)
Rails.autoloaders.main.push_dir(ENGINE.join("app/components/renalware"), namespace: Renalware)

Rails.autoloaders.main.collapse(ENGINE.join("app/components/shared/*"))
