# frozen_string_literal: true

class Shared::Icon < Shared::Base
  register_output_helper :inline_svg, mark_safe: true

  SIZES = {
    xs: "h-3 w-3",
    sm: "h-4 w-4",
    md: "h-5 w-5",
    lg: "h-6 w-6",
    xl: "h-7 w-7"
  }.freeze

  def initialize(name, size: :md)
    @name = name
    @size = SIZES[size]
    super()
  end

  def view_template
    inline_svg("renalware/icons/#{@name}.svg", class: @size)
  end
end
