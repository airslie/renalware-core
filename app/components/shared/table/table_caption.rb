# frozen_string_literal: true

class Shared::TableCaption < Shared::Base
  def view_template(&)
    caption(**attrs, &)
  end
end
