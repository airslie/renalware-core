# frozen_string_literal: true

class Shared::TableHeader < Shared::Base
  def view_template(&)
    thead(**attrs, &)
  end
end
