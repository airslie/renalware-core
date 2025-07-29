# frozen_string_literal: true

class Shared::Badge < Shared::Base
  def initialize(**attrs)
    @label = attrs.delete(:label)
    @color = attrs.delete(:color)
    super
  end

  def view_template
    div(**mix({ class: "block rounded px-2 py-0 #{css}" }, attrs)) { label }
  end

  private

  attr_reader :label, :color

  def css
    css = "#{color} text-white" if color&.split("-")&.last.to_i >= 500
    css || color
  end
end
