# frozen_string_literal: true

class Shared::Badge < Shared::Base
  def initialize(value, colors:, **attrs)
    @value = value
    @colors = colors
    super(**attrs)
  end

  def view_template
    div(**mix({ class: "block rounded px-2 py-0 #{colors}" }, attrs)) { value }
  end

  private

  attr_reader :value

  def colors
    color = @colors.fetch(value, nil)
    color = "#{color} text-white" if color&.split("-")&.last.to_i >= 500
    color
  end
end
