# frozen_string_literal: true

class Shared::Table < Shared::Base
  def view_template(**attrs, &)
    table(**attrs, &)
  end

  private

  def default_attrs = { class: "plx" }
end
