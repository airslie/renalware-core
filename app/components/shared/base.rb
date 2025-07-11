# frozen_string_literal: true

require "tailwind_merge"

class Shared::Base < Phlex::HTML
  include Phlex::Rails::Helpers::Routes
  include ::Renalware::Engine.routes.url_helpers # paths without `renalware.` prefix

  TAILWIND_MERGER = ::TailwindMerge::Merger.new.freeze

  attr_reader :attrs

  def initialize(**user_attrs)
    @attrs = mix(default_attrs, user_attrs)
    @attrs[:class] = TAILWIND_MERGER.merge(@attrs[:class]) if @attrs[:class]
    super()
  end

  if Rails.env.development?
    def before_template
      comment { "Before #{self.class.name}" }
      super
    end
  end

  private

  def default_attrs = {}

  # FIXME: Copied from AttributeNameHelper
  def attr_name(model, attr, suffix: ":")
    klass = model.is_a?(Class) ? model : model.class
    klass.human_attribute_name(attr) + String(suffix)
  end
end
